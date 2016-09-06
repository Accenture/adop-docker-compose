#!/bin/bash -e
#############
# This is a library of functions 
# used by adop cli
#############

load_credentials() {
  # Load the credentials to connet to the TARGET_HOST (adop stack)
  if [ -f "${CLI_DIR}/.adop/target" ]; then
    echo "Loading the credentials.."
    source ${CLI_DIR}/.adop/target
    export TARGET_HOST=$(echo ${ADOP_CLI_ENDPOINT} | sed 's#/$##')
  else
    echo "ERROR : Failed to load the credentials"
    echo "Set up the target host using 'adop target' command."
  fi
}

check_job_status() {
  set +e
  JOB_STATUS_URL=${JOB_URL}/api/json?
  BUILD_STATUS_URL=${JOB_URL}/lastBuild/api/json?tree=result
  GREP_RC=0
  GREP_RC1=0
  GREP_RC2=0
  while [ $GREP_RC -eq 0 ]
  do
      echo "Waiting for job to complete..."
      sleep 10
      
      while [ $GREP_RC1 -eq 0 ]
      do
          echo "Checking if job has been built previously or if build has initialised..."
          sleep 10
          curl --silent -u ${ADOP_CLI_USER}:${ADOP_CLI_PASSWORD} $JOB_STATUS_URL | grep 'lastBuild":null' > /dev/null
          GREP_RC1=$?
      done
      
      while [ $GREP_RC2 -eq 0 ]
      do
          echo "Checking if build is in queue..."
          sleep 10
          curl --silent -u ${ADOP_CLI_USER}:${ADOP_CLI_PASSWORD} $JOB_STATUS_URL | grep 'inQueue":true' > /dev/null
          GREP_RC2=$?
      done
      
      curl --silent -u ${ADOP_CLI_USER}:${ADOP_CLI_PASSWORD} $BUILD_STATUS_URL | grep 'result":null' > /dev/null
      GREP_RC=$?
  done

  curl --silent -u ${ADOP_CLI_USER}:${ADOP_CLI_PASSWORD} $BUILD_STATUS_URL | grep 'result":"SUCCESS' > /dev/null
  if [ $? -ne 0 ]; then
      echo "Unable to complete the job. Please check ${JOB_URL}"
      exit 1
  fi
  set -e
}

