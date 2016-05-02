#!/bin/bash -e

echo ' 
      ###    ########   #######  ########  
     ## ##   ##     ## ##     ## ##     ## 
    ##   ##  ##     ## ##     ## ##     ## 
   ##     ## ##     ## ##     ## ########  
   ######### ##     ## ##     ## ##        
   ##     ## ##     ## ##     ## ##        
   ##     ## ########   #######  ##        
'

usage(){
  echo "Usage:"
  echo "        ./quickstart.sh -t local [-m <MACHINE_NAME>] [-u <INITIAL_ADMIN_USER>] [-p <INITIAL_ADMIN_PASSWORD>]"
  echo "        ./quickstart.sh -t aws -m <MACHINE_NAME> -c <VPC_ID> [-r <REGION>] [-z <AVAILABILITY_ZONE_LETTER>] [-a <AWS_ACCESS_KEY>] [-s <AWS_SECRET_ACCESS_KEY>] [-u <INITIAL_ADMIN_USER>] [-p <INITIAL_ADMIN_PASSWORD>]"
}

provision_local() {
    if [ -z ${MACHINE_NAME} ]; then
        MACHINE_NAME=adop
    fi

    # Create Docker machine if one doesn't already exist with the same name
    if $(docker-machine env $MACHINE_NAME > /dev/null 2>&1) ; then
        echo "Docker machine '$MACHINE_NAME' already exists"
    else
        docker-machine create --driver virtualbox --virtualbox-memory 2048 ${MACHINE_NAME}
    fi
}

provision_aws() {
    if [ -z ${MACHINE_NAME} ] | \
       [ -z ${VPC_ID} ]; then
        usage
        exit 1
    fi

    if [ -z ${VPC_AVAIL_ZONE} ]; then
        echo "No availability zone specified - using default [a]."
        export VPC_AVAIL_ZONE=a
    elif [[ ! ${VPC_AVAIL_ZONE} =~ ^[a-e]{1,1}$ ]]; then
            echo "Availability zone can only be a single lower case char, 'a' to 'e'. Exiting..."
            exit 1
    fi

    if [ -z ${AWS_ACCESS_KEY_ID} ] & \
        [ -f ~/.aws/credentials ];
    then
      echo "Using default AWS credentials from ~/.aws/credentials"
      eval $(grep -v '^\[' ~/.aws/credentials | sed 's/^\(.*\)\s=\s/export \U\1=/')
    fi

    if [ -z ${AWS_DEFAULT_REGION} ] & \
        [ -f ~/.aws/config ];
    then
      echo "Using default AWS region from ~/.aws/config"
      eval $(grep -v '^\[' ~/.aws/config | sed 's/^\(region\)\s\?=\s\?/export AWS_DEFAULT_REGION=/')
    fi

    # Create Docker machine if one doesn't already exist with the same name
    if $(docker-machine env $MACHINE_NAME > /dev/null 2>&1) ; then
        echo "Docker machine '$MACHINE_NAME' already exists"
    else
      if [ -z ${AWS_ACCESS_KEY_ID} ]; then
        docker-machine create --driver amazonec2 --amazonec2-vpc-id ${VPC_ID} --amazonec2-zone ${VPC_AVAIL_ZONE} --amazonec2-instance-type m4.xlarge ${MACHINE_NAME}
      else
        docker-machine create --driver amazonec2 --amazonec2-access-key ${AWS_ACCESS_KEY_ID} --amazonec2-secret-key ${AWS_SECRET_ACCESS_KEY} --amazonec2-vpc-id ${VPC_ID} --amazonec2-zone ${VPC_AVAIL_ZONE} --amazonec2-instance-type m4.xlarge --amazonec2-region ${AWS_DEFAULT_REGION} ${MACHINE_NAME}
      fi
    fi
}

while getopts "t:m:a:s:c:z:r:u:p:" opt; do
  case ${opt} in
    t)
      MACHINE_TYPE=${OPTARG}
      ;;
    m)
      export MACHINE_NAME=${OPTARG}
      ;;
    a)
      export AWS_ACCESS_KEY_ID=${OPTARG}
      ;;
    s)
      export AWS_SECRET_ACCESS_KEY=${OPTARG}
      ;;
    c)
      export VPC_ID=${OPTARG}
      ;;
    z)
      export VPC_AVAIL_ZONE=${OPTARG}
      ;;
    r)
      export AWS_DEFAULT_REGION=${OPTARG}
      ;;
    u)
      export INITIAL_ADMIN_USER=${OPTARG}
      ;;
    p)
      export INITIAL_ADMIN_PASSWORD_PLAIN=${OPTARG}
      ;;
    *)
      echo "Invalid parameter(s) or option(s)."
      usage
      exit 1
      ;;
  esac
done

if [ -z ${MACHINE_TYPE} ]; then
    echo "Please specify a machine type to create during quickstart"
    usage
    exit 1
fi

# Switch based on the machine type
case ${MACHINE_TYPE} in
    "local")
        provision_local
        ;;
    "aws")
        provision_aws
        ;;
    *)
        echo "Invalid parameter(s) or option(s)."
        usage
        exit 1
        ;;
esac

# Use the ADOP CLI
./adop compose -m "${MACHINE_NAME}" init

