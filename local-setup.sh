#!/bin/bash -e
#
# 
# usage local-setup.sh [docker-machine] [user-name] [password]
#
# [docker-machine] : the name of the docker-machine to be created/used. (defaults to adop)
# [user-name] : initial admin username for the tools (will be prompted for one if not provided)
# [password] : password for the initial admin user (will be randomly generated and printed if not provided)
#

OVERRIDES=

# Defaults
export VOLUME_DRIVER=local
export LOGGING_OVERRIDE=' -f etc/logging/syslog/default.yml'
export CUSTOM_NETWORK_NAME=adopnetwork

if [[ -z "$1" ]]; then
	MACHINE_NAME=adop
else
	MACHINE_NAME="$1"
fi

if [[ -z "$2" ]]; then
	echo
else
	export ADMIN_USER="$2"
fi

if [[ -z "$3" ]]; then
	echo
else
	export PASSWORD="$3"
fi

source credentials.config.sh
source env.config.sh

# Create Docker machine if one doesn't already exist with the same name
if $(docker-machine env $MACHINE_NAME > /dev/null 2>&1) ; then
  echo "Docker machine '$MACHINE_NAME' already exists"
else
  docker-machine create --driver virtualbox --virtualbox-memory 2048 $MACHINE_NAME
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
echo '  source env.config.sh'
echo
echo Navigate to http://$TARGET_HOST in your browser to use your new DevOps Platform!

