#!/bin/bash -e

OVERRIDES=

usage(){
	echo "Usage: ./startup.sh -m <MACHINE_NAME> -a <AWS_ACCESS_KEY> -s <AWS_SECRET_ACCESS_KEY> -c <VPC_ID> -r <REGION> -v <VOLUME_DRIVER> -n <CUSTOM_NETWORK_NAME>(optional) -l LOGGING_DRIVER(optional) -f path/to/additional_override1.yml(optional) -f path/to/additional_override2.yml(optional) ..."
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
      export AWS_ACCESS_KEY=${OPTARG}
      ;;
    s)
      export AWS_SECRET_ACCESS_KEY=${OPTARG}
      ;;
    c)
      export VPC_ID=${OPTARG}
      ;;
    r)
      export REGION=${OPTARG}
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
	[ -z $AWS_ACCESS_KEY ] | \
	[ -z $VPC_ID ] | \
	[ -z $REGION ]; then
  usage
  exit 1
fi

source env.config.sh

# Create Docker machine if one doesn't already exist with the same name
if $(docker-machine env $MACHINE_NAME > /dev/null 2>&1) ; then
	echo "Docker machine '$MACHINE_NAME' already exists"
else
  docker-machine create --driver amazonec2 --amazonec2-access-key $AWS_ACCESS_KEY --amazonec2-secret-key $AWS_SECRET_ACCESS_KEY --amazonec2-vpc-id $VPC_ID --amazonec2-instance-type t2.large --amazonec2-region $REGION $MACHINE_NAME
fi

# Create Docker network if one doesn't already exist with the same name
eval "$(docker-machine env $MACHINE_NAME)"
if ! docker network create $CUSTOM_NETWORK_NAME; then
	echo "Docker network '$CUSTOM_NETWORK_NAME' already exists"
fi

export TARGET_HOST=$(docker-machine ip $MACHINE_NAME)
export LOGSTASH_HOST=$(docker-machine ip $MACHINE_NAME)
docker-compose -f compose/elk.yml pull
docker-compose -f docker-compose.yml -f etc/volumes/${VOLUME_DRIVER}/default.yml $LOGGING_OVERRIDE ${OVERRIDES} pull
set -x
docker-compose -f compose/elk.yml up -d
docker-compose -f docker-compose.yml -f etc/volumes/${VOLUME_DRIVER}/default.yml $LOGGING_OVERRIDE ${OVERRIDES} up -d
set +x

# Wait for Jenkins and Gerrit to come up before proceeding
until [[ $(docker exec jenkins curl -I -s jenkins:jenkins@localhost:8080/jenkins/|head -n 1|cut -d$' ' -f2) == 200 ]]; do echo \"Jenkins unavailable, sleeping for 60s\"; sleep 60; done
until [[ $(docker exec gerrit curl -I -s gerrit:gerrit@localhost:8080/gerrit/|head -n 1|cut -d$' ' -f2) == 200 ]]; do echo \"Gerrit unavailable, sleeping for 60s\"; sleep 60; done

# Trigger Load_Platform in Jenkins
docker exec jenkins curl -X POST jenkins:jenkins@localhost:8080/jenkins/job/Load_Platform/buildWithParameters \
	--data token=gAsuE35s \

echo "Run this command in your shell: eval \"$(docker-machine env $MACHINE_NAME)\""

# Generate and copy the certificates to jenkins slave
$(pwd)/generate_client_certs.sh ${DOCKER_CLIENT_CERT_PATH} >/dev/null 2>&1

