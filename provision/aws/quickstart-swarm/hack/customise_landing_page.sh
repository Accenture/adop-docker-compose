#!/bin/bash -e

# This is a transfer tool that can be used to customised the DevOps Landing page
# Might be put to good use someday for Oracle Landing pages...

export DOCKER_HOST=""

if [[ -z $1 ]]; then
  echo "Usage: ./customise_landing_page.sh ProjectName"
  exit 1
fi

if [[ $1 == 'GitlabExtension' ]]; then
  echo "GitlabExtension is enabled by default.."
  exit 0
fi 

if [[ ! -d /data/adop-docker-compose/custom/proxy/${1} ]]; then
  echo "/data/adop-docker-compose/custom/proxy/${1} does not exist."
  echo "Currently available:"
  echo $(ls /data/adop-docker-compose/custom/proxy)
  exit 1
fi

# Run transfer.sh
cd /data/adop-docker-compose/custom/proxy/${1}
./transfer.sh
