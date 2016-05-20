#!/bin/bash -e

OVERRIDES="-f etc/aws/default.yml"


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
  cat <<END_USAGE

Usage: ./startup.sh
   -m <MACHINE_NAME>
   -c <VPC_ID>
   -z <VPC_AVAIL_ZONE>(optional)
   -r <REGION>(optional)
   -a <AWS_ACCESS_KEY>(optional)
   -s <AWS_SECRET_ACCESS_KEY>(optional)
   -v <VOLUME_DRIVER>(optional)
   -n <CUSTOM_NETWORK_NAME>(optional)
   -l LOGGING_DRIVER(optional)
   -f path/to/additional_override1.yml(optional)
   -f path/to/additional_override2.yml(optional)
   -u <INITIAL_ADMIN_USER>(optional)
   -p <INITIAL_ADMIN_PASSWORD>(optional)
   -b <SUBNET_ID>(optional)
   -k <AWS_KEYPAIR>(optional)
   -x <INSTANCE_TYPE>(optional)...

END_USAGE
}

# Defaults
export VOLUME_DRIVER=local
export LOGGING_OVERRIDE=' -f etc/logging/syslog/default.yml'
export CUSTOM_NETWORK_NAME=adopnetwork


while getopts "m:n:a:s:c:z:r:f:v:l:u:p:b:k:x:" opt; do
  case $opt in
    m)
      export MACHINE_NAME=${OPTARG}
      ;;
    n)
      ${OPTARG}
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
    z)
      export VPC_AVAIL_ZONE=${OPTARG}
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
	  u)
      export INITIAL_ADMIN_USER=${OPTARG}
      ;;
    p)
      export INITIAL_ADMIN_PASSWORD_PLAIN=${OPTARG}
      ;;
    b)
      export SUBNET_ID=${OPTARG}
      ;;
    k)
      export AWS_KEYPAIR=${OPTARG}
      ;;
    x)
      export INSTANCE_TYPE=${OPTARG}
      ;;
    *)
      echo "Invalid parameter(s) or option(s)."
      usage
      exit 1
      ;;
  esac
done

# Function to create AWS-specific environment variables file
source_aws() {
  if [ -f ./env.aws.sh ]; then
  
    echo "Your AWS parameters file already exists, re-sourcing parameters and moving on..."
    echo "If you would like to use new AWS parameters, please delete env.aws.sh and re-run this script."
  
  else
   
    echo "Creating a new AWS variables file..."
    > env.aws.sh
    
    echo "# Shell script to store AWS-specific environment variables" >> env.aws.sh
    echo "# Can be sourced and re-sourced to keep variables in shell instance" >> env.aws.sh

    echo "" >> env.aws.sh

    echo "export VPC_ID='${VPC_ID}'" >> env.aws.sh

    # AWS-specific environment variables
    if [ -z ${AWS_KEYPAIR} ]; then
      echo "export AWS_KEYPAIR='${MACHINE_NAME}'" >> env.aws.sh
    else
      echo "export AWS_KEYPAIR='${AWS_KEYPAIR}'" >> env.aws.sh
    fi

    if [ -z ${INSTANCE_TYPE} ]; then
      echo "export INSTANCE_TYPE='t2.large'" >> env.aws.sh
    else
      echo "export INSTANCE_TYPE='${INSTANCE_TYPE}'" >> env.aws.sh
    fi

    if [ -z ${SUBNET_ID} ]; then
      echo "export SUBNET_ID='default'" >> env.aws.sh
    else
      echo "export SUBNET_ID='${SUBNET_ID}'" >> env.aws.sh
    fi
  
  fi
}

if [ -z $MACHINE_NAME ] | \
	[ -z $CUSTOM_NETWORK_NAME ] | \
	[ -z $VPC_ID ]; then
  usage
  exit 1
fi

if [ -z $VPC_AVAIL_ZONE ]; then
    echo "No availability zone specified - using default [a]."
    # Driver amazonec2 defaults to zone a but setting explicitly here to
    # guard against side effects in command below if using parameter with no
    # value.
    export VPC_AVAIL_ZONE=a
elif [[ ! $VPC_AVAIL_ZONE =~ ^[a-e]{1,1}$ ]]; then
        echo "Availability zone can only be a single lower case char, 'a' to 'e'. Exiting..."
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

source_aws

# Source environment variables and set up default admin credentials
source env.aws.sh
source credentials.generate.sh
source env.config.sh

# Allow script to continue if error returned by docker-machine command
set +e

# Create Docker machine if one doesn't already exist with the same name
docker-machine ip ${MACHINE_NAME} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Docker machine '${MACHINE_NAME}' already exists."
else

    MACHINE_CREATE_CMD="docker-machine create \
                            --driver amazonec2 \
                            --amazonec2-vpc-id ${VPC_ID} \
			    --amazonec2-zone $VPC_AVAIL_ZONE \
			    --amazonec2-instance-type m4.xlarge"

    if [ -n "${AWS_ACCESS_KEY_ID}" ]; then
        MACHINE_CREATE_CMD="${MACHINE_CREATE_CMD} \
	                        --amazonec2-access-key $AWS_ACCESS_KEY_ID \
				--amazonec2-secret-key $AWS_SECRET_ACCESS_KEY \
				--amazonec2-region $AWS_DEFAULT_REGION"
    fi

    MACHINE_CREATE_CMD="${MACHINE_CREATE_CMD} ${MACHINE_NAME}"

    ${MACHINE_CREATE_CMD}

fi

# Reenable errexit
set -e

# Create Docker network if one doesn't already exist with the same name
eval "$(docker-machine env $MACHINE_NAME --shell bash)"
if ! docker network create $CUSTOM_NETWORK_NAME; then
	echo "Docker network '$CUSTOM_NETWORK_NAME' already exists"
fi

# Run the Docker compose commands
export TARGET_HOST=$(docker-machine ip $MACHINE_NAME)
export LOGSTASH_HOST=$(docker-machine ip $MACHINE_NAME)
export HOST_IP=$(docker-machine inspect --format='{{.Driver.PrivateIPAddress}}' $MACHINE_NAME)
docker-compose -f compose/elk.yml pull
docker-compose -f docker-compose.yml -f etc/volumes/${VOLUME_DRIVER}/default.yml $LOGGING_OVERRIDE ${OVERRIDES} pull
docker-compose -f compose/elk.yml up -d
docker-compose -f docker-compose.yml -f etc/volumes/${VOLUME_DRIVER}/default.yml $LOGGING_OVERRIDE ${OVERRIDES} up -d

# Wait for Jenkins and Gerrit to come up before proceeding
until [[ $(docker exec jenkins curl -I -s jenkins:$PASSWORD_JENKINS@localhost:8080/jenkins/|head -n 1|cut -d$' ' -f2) == 200 ]]; do echo \"Jenkins unavailable, sleeping for 60s\"; sleep 60; done
until [[ $(docker exec gerrit curl -I -s gerrit:$PASSWORD_GERRIT@localhost:8080/gerrit/|head -n 1|cut -d$' ' -f2) == 200 ]]; do echo \"Gerrit unavailable, sleeping for 60s\"; sleep 60; done

# Trigger Load_Platform in Jenkins
docker exec jenkins curl -X POST jenkins:$PASSWORD_JENKINS@localhost:8080/jenkins/job/Load_Platform/buildWithParameters \
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
echo '  source env.aws.sh'
echo '  source credentials.generate.sh'
echo '  source env.config.sh'
echo
echo Navigate to http://$TARGET_HOST in your browser to use your new DevOps Platform!
echo Login using the following credentials:
echo Username: $INITIAL_ADMIN_USER
echo Password: $INITIAL_ADMIN_PASSWORD_PLAIN
