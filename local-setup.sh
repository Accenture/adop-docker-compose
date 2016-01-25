#
# 
# usage local-setup.sh [docker-machine]
#
# [docker-machine] : the name of the docker-machine to be created/used. (defaults to adop)
#
source env.config.sh

if [[ -z "$1" ]]; then
  DOCKER_MACHINE=adop
else
  DOCKER_MACHINE="$1"
fi

if ( docker-machine ls | grep -q "^$DOCKER_MACHINE " ) ; then 
  echo "$0: machine exists, no need to create."
else
  docker-machine create --driver virtualbox --virtualbox-memory 2048 adop
fi

eval $( docker-machine env $DOCKER_MACHINE )

export TARGET_HOST=$( docker-machine ip $DOCKER_MACHINE )
export LOGSTASH_HOST=$( docker-machine ip $DOCKER_MACHINE )
export CUSTOM_NETWORK_NAME=adop

if ( docker network ls | grep -q " $DOCKER_MACHINE " ) ; then 
  echo "$0: network exists, no need to create."
else
  docker network create $CUSTOM_NETWORK_NAME
fi

docker-compose -f compose/elk.yml up -d

docker-compose pull

. ./env.config.sh

docker-compose -f docker-compose.yml -f etc/volumes/local/default.yml -f etc/logging/syslog/default.yml up -d
