#!/bin/bash -e

OVERRIDES=


echo ' 
      ###    ########   #######  ########  
     ## ##   ##     ## ##     ## ##     ## 
    ##   ##  ##     ## ##     ## ##     ## 
   ##     ## ##     ## ##     ## ########  
   ######### ##     ## ##     ## ##        
   ##     ## ##     ## ##     ## ##        
   ##     ## ########   #######  ##        
'

usage(){
  echo "Usage: ./startup.sh -m <MACHINE_NAME> -c <VPC_ID> -r <REGION>(optional) -a <AWS_ACCESS_KEY>(optional) -s <AWS_SECRET_ACCESS_KEY>(optional) -v <VOLUME_DRIVER>(optional) -n <CUSTOM_NETWORK_NAME>(optional) -l LOGGING_DRIVER(optional) -f path/to/additional_override1.yml(optional) -f path/to/additional_override2.yml(optional) ..."
}

# Defaults
export VOLUME_DRIVER=local
export LOGGING_OVERRIDE=' -f etc/logging/syslog/default.yml'
export CUSTOM_NETWORK_NAME=adopnetwork


while getopts "m:n:a:s:c:r:f:v:l:" opt; do
  case $opt in
    m)
      export MACHINE_NAME=${OPTARG}
      ;;
    n)
      export CUSTOM_NETWORK_NAME=${OPTARG}
      ;;
    a)
      export AWS_ACCESS_KEY_ID=${OPTARG}
      ;;
    s)
      export AWS_SECRET_ACCESS_KEY=${OPTARG}
      ;;
    c)
      export VPC_ID=${OPTARG}
      ;;
    r)
      export AWS_DEFAULT_REGION=${OPTARG}
      ;;
    v)
      export VOLUME_DRIVER=${OPTARG}
      ;;
    f)
      export OVERRIDES="${OVERRIDES} -f ${OPTARG}"
      ;;
    l)
      export LOGGING_OVERRIDE=" -f ${OPTARG}"
      ;;
    *)
      echo "Invalid parameter(s) or option(s)."
      usage
      exit 1
      ;;
  esac
done

if [ -z $MACHINE_NAME ] | \
	[ -z $CUSTOM_NETWORK_NAME ] | \
	[ -z $VPC_ID ]; then
  usage
  exit 1
fi

if [ -z $AWS_ACCESS_KEY_ID ] & \
    [ -f ~/.aws/credentials ];
then
  echo "Using default AWS credentials from ~/.aws/credentials"
  eval $(grep -v '^\[' ~/.aws/credentials | sed 's/^\(.*\)\s=\s/export \U\1=/')
fi

if [ -z $AWS_DEFAULT_REGION ] & \
    [ -f ~/.aws/config ];
then
  echo "Using default AWS region from ~/.aws/config"
  eval $(grep -v '^\[' ~/.aws/config | sed 's/^\(region\)\s\?=\s\?/export AWS_DEFAULT_REGION=/')
fi

source env.config.sh

# Create Docker machine if one doesn't already exist with the same name
if $(docker-machine env $MACHINE_NAME > /dev/null 2>&1) ; then
	echo "Docker machine '$MACHINE_NAME' already exists"
else
  if [ -z $AWS_ACCESS_KEY_ID ]; then
    docker-machine create --driver amazonec2 --amazonec2-vpc-id $VPC_ID --amazonec2-instance-type t2.large $MACHINE_NAME
  else
    docker-machine create --driver amazonec2 --amazonec2-access-key $AWS_ACCESS_KEY_ID --amazonec2-secret-key $AWS_SECRET_ACCESS_KEY --amazonec2-vpc-id $VPC_ID --amazonec2-instance-type t2.large --amazonec2-region $AWS_DEFAULT_REGION $MACHINE_NAME
  fi
fi

# Create Docker network if one doesn't already exist with the same name
eval "$(docker-machine env $MACHINE_NAME)"
if ! docker network create $CUSTOM_NETWORK_NAME; then
	echo "Docker network '$CUSTOM_NETWORK_NAME' already exists"
fi

# Run the Docker compose commands
export TARGET_HOST=$(docker-machine ip $MACHINE_NAME)
export LOGSTASH_HOST=$(docker-machine ip $MACHINE_NAME)
docker-compose -f compose/elk.yml pull
docker-compose -f docker-compose.yml -f etc/volumes/${VOLUME_DRIVER}/default.yml $LOGGING_OVERRIDE ${OVERRIDES} pull
docker-compose -f compose/elk.yml up -d
docker-compose -f docker-compose.yml -f etc/volumes/${VOLUME_DRIVER}/default.yml $LOGGING_OVERRIDE ${OVERRIDES} up -d

# Wait for Jenkins and Gerrit to come up before proceeding
until [[ $(docker exec jenkins curl -I -s jenkins:jenkins@localhost:8080/jenkins/|head -n 1|cut -d$' ' -f2) == 200 ]]; do echo \"Jenkins unavailable, sleeping for 60s\"; sleep 60; done
until [[ $(docker exec gerrit curl -I -s gerrit:gerrit@localhost:8080/gerrit/|head -n 1|cut -d$' ' -f2) == 200 ]]; do echo \"Gerrit unavailable, sleeping for 60s\"; sleep 60; done

# Trigger Load_Platform in Jenkins
docker exec jenkins curl -X POST jenkins:jenkins@localhost:8080/jenkins/job/Load_Platform/buildWithParameters \
	--data token=gAsuE35s \

# Generate and copy the certificates to jenkins slave
$(pwd)/generate_client_certs.sh ${DOCKER_CLIENT_CERT_PATH} 1> /dev/null

# Tell the user something useful
echo
echo '##########################################################'
echo
echo SUCCESS, your new ADOP instance is ready!
echo
echo Run these commands in your shell:
echo '  eval \"$(docker-machine env $MACHINE_NAME)\"'
echo '  source env.config.sh'
echo
echo Navigate to http://$TARGET_HOST in your browser to use your new DevOps Platform!

