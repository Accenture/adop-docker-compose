#!/bin/bash

DIR=$(pwd)

if [ -z $AWS_ACCESS_KEY ]; then
  echo "AWS_ACCESS_KEY not set"
  exit 1
fi

if [ -z $AWS_SECRET_ACCESS_KEY ]; then
  echo "AWS_SECRET_ACCESS_KEY not set"
  exit 1
fi

if [ -z $MACHINE_NAME ]; then
  echo "MACHINE_NAME not set"
  exit 1
fi

docker-machine create --driver amazonec2 --amazonec2-access-key $AWS_ACCESS_KEY --amazonec2-secret-key $AWS_SECRET_ACCESS_KEY --amazonec2-vpc-id vpc-27d43742 --amazonec2-instance-type t2.large --amazonec2-region eu-west-1 $MACHINE_NAME

eval "$(/usr/local/bin/docker-machine env $MACHINE_NAME)"
export TARGET_HOST=$(docker-machine ip $MACHINE_NAME)
export LOGSTASH_HOST=$(docker-machine ip $MACHINE_NAME)
docker-compose -f docker-compose-no-init.yml up -d

sleep 10

docker-machine ssh $MACHINE_NAME "rm -rf /home/ubuntu/volumes/; mkdir -p /home/ubuntu/volumes; sudo rm -rf $DIR/volumes/nginx-configuration-vol/ $DIR/volumes/nginx-releasenote-vol/; sudo mkdir -p $DIR/volumes"
docker-machine scp -r $DIR/volumes/nginx-configuration-vol/ $MACHINE_NAME:/home/ubuntu/volumes/
docker-machine scp -r $DIR/volumes/nginx-releasenote-vol/ $MACHINE_NAME:/home/ubuntu/volumes/
docker-machine ssh $MACHINE_NAME "sudo su -c 'mv -f /home/ubuntu/volumes/nginx-configuration-vol $DIR/volumes/; mv -f /home/ubuntu/volumes/nginx-releasenote-vol $DIR/volumes/; cd $DIR/volumes; chown -R 1000:1000 gerrit-site-vol jenkins-home-vol git-repos-vol'"

docker exec dockercompose_ldap_1 bash -c '/usr/local/bin/load_ldif.sh -h $(hostname) -u cn=admin,dc=adop,dc=accenture,dc=com -p ***REMOVED*** -b dc=adop,dc=accenture,dc=com -f /tmp/structure.ldif'

docker-compose restart
