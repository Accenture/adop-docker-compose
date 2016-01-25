#!/bin/bash -xe

OVERRIDES=

usage(){
	echo " 
Usage: $ startup.sh <MACHINE_NAME> <CUSTOM_NETWORK_NAME> <VOLUME_DRIVER> <AWS_ACCESS_KEY> <AWS_SECRET_ACCESS_KEY> <VPC_ID> <REGION>

	MACHINE_NAME name the instance that will be created in AWS (anything you like)
	CUSTOM_NETWORK_NAME name the Docker network that will be created (anything you like)
	VOLUME_DRIVER use local unless you have an available nfs server 
	AWS_ACCESS_KEY your aws credentials (needs IAM permissions to create EC2)
	AWS_SECRET_ACCESS_KEY your aws credentials (needs IAM permissions to create EC2)
	VPC_ID name of a pre-existing VPC in which to create the instance (by default the instance will be placed into the default subnet in this).  Needs to have a public subnet so that you can access the ADOP instance.
	REGION target AWS region (in the format like: eu-west-1)
"
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
      ;;
  esac
done

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
