#!/bin/bash

export MACHINE_NAME=$1
export CUSTOM_NETWORK_NAME=$2
export VOLUME_DRIVER=$3
export AWS_ACCESS_KEY=$4
export AWS_SECRET_ACCESS_KEY=$5

DIR=$(pwd)/docker-compose

usage(){
	echo "Usage: source startup.sh <MACHINE_NAME> <CUSTOM_NETWORK_NAME> <VOLUME_DRIVER> <AWS_ACCESS_KEY> <AWS_SECRET_ACCESS_KEY>"
}

if [ -z $AWS_ACCESS_KEY ]; then
  echo "AWS_ACCESS_KEY not set"
  usage
  exit 1
fi

if [ -z $AWS_SECRET_ACCESS_KEY ]; then
  echo "AWS_SECRET_ACCESS_KEY not set"
  usage
  exit 1
fi

if [ -z $MACHINE_NAME ]; then
  echo "MACHINE_NAME not set"
  usage
  exit 1
fi

if [ -z $CUSTOM_NETWORK_NAME ]; then
  echo "CUSTOM_NETWORK_NAME not set"
  usage
  exit 1
fi

docker-machine create --driver amazonec2 --amazonec2-access-key $AWS_ACCESS_KEY --amazonec2-secret-key $AWS_SECRET_ACCESS_KEY --amazonec2-vpc-id vpc-27d43742 --amazonec2-instance-type t2.large --amazonec2-region eu-west-1 $MACHINE_NAME

eval "$(/usr/local/bin/docker-machine env $MACHINE_NAME)"
export TARGET_HOST=$(docker-machine ip $MACHINE_NAME)
export LOGSTASH_HOST=$(docker-machine ip $MACHINE_NAME)
docker network create $CUSTOM_NETWORK_NAME
docker-compose -f docker-compose/docker-compose.yml -f docker-compose/etc/volumes/${VOLUME_DRIVER}/default.yml up -d
