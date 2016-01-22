#!/bin/bash

export MACHINE_NAME=$1
export CUSTOM_NETWORK_NAME=$2
export VOLUME_DRIVER=$3
export AWS_ACCESS_KEY=$4
export AWS_SECRET_ACCESS_KEY=$5
export VPC_ID=$6
export REGION=$7

usage(){
	echo "Usage: source startup.sh <MACHINE_NAME> <CUSTOM_NETWORK_NAME> <VOLUME_DRIVER> <AWS_ACCESS_KEY> <AWS_SECRET_ACCESS_KEY> <VPC_ID> <REGION>"
}

if [ -z $MACHINE_NAME ] | \
	[ -z $CUSTOM_NETWORK_NAME ] | \
	[ -z $AWS_ACCESS_KEY ] | \
	[ -z $AWS_SECRET_ACCESS_KEY ] | \
	[ -z $VPC_ID ] | \
	[ -z $REGION ]; then
  usage
  exit 1
fi

docker-machine create --driver amazonec2 --amazonec2-access-key $AWS_ACCESS_KEY --amazonec2-secret-key $AWS_SECRET_ACCESS_KEY --amazonec2-vpc-id $VPC_ID --amazonec2-instance-type t2.large --amazonec2-region $REGION $MACHINE_NAME

eval "$(/usr/local/bin/docker-machine env $MACHINE_NAME)"
export TARGET_HOST=$(docker-machine ip $MACHINE_NAME)
export LOGSTASH_HOST=$(docker-machine ip $MACHINE_NAME)
docker network create $CUSTOM_NETWORK_NAME
docker-compose pull
docker-compose -f docker-compose.yml -f etc/volumes/${VOLUME_DRIVER}/default.yml up -d
