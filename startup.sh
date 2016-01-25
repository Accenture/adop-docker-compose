#!/bin/bash -xe

OVERRIDES=

usage(){
	echo "Usage: ./startup.sh -m <MACHINE_NAME> -n <CUSTOM_NETWORK_NAME> -a <AWS_ACCESS_KEY> -s <AWS_SECRET_ACCESS_KEY> -c <VPC_ID> -r <REGION> -f path/to/override1.yml -f path/to/override2.yml ..."
}

while getopts "m:n:a:s:c:r:f:" opt; do
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
    f)
      export OVERRIDES="${OVERRIDES} -f ${OPTARG}"
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

docker-machine create --driver amazonec2 --amazonec2-access-key $AWS_ACCESS_KEY --amazonec2-secret-key $AWS_SECRET_ACCESS_KEY --amazonec2-vpc-id $VPC_ID --amazonec2-instance-type t2.large --amazonec2-region $REGION $MACHINE_NAME
eval "$(/usr/local/bin/docker-machine env $MACHINE_NAME)"
export TARGET_HOST=$(docker-machine ip $MACHINE_NAME)
export LOGSTASH_HOST=$(docker-machine ip $MACHINE_NAME)
docker network create $CUSTOM_NETWORK_NAME
docker-compose -f compose/elk.yml up -d
docker-compose pull
docker-compose -f docker-compose.yml -f etc/volumes/${VOLUME_DRIVER}/default.yml -f etc/logging/syslog/default.yml up -d
echo Your ADOP is ready.  
echo You will need to update the docker-machine security group to permit inbound http traffic on port 80
