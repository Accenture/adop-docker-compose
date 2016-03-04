#!/bin/bash -e

CERT_PATH=$1
REGISTRY_HOST=$2
MACHINE_NAME=$3
echo ${CERT_PATH}
if [ -z ${CERT_PATH} ]; then
    echo "
	  Usage : 
		$0 <docker_registry_certificate_path>
	  
	  <docker_registry_certificate_path>: 
		This is the path of the certificate on the docker registry
        container. It should be copied to any other daemon using
        this registry
		Note - absolute path is required.
    	  
	  Example: 
		$0 /root/.docker
    "
    exit 1
fi

###
# Windows Git bash terminal identifies 
# /CN=client as a path and appends the absolute path 
# of parent directory to it
####
HOST_OS=$(uname)
CLIENT_SUBJ="/CN=$REGISTRY_HOST"
if echo "${HOST_OS}" | grep -E "MINGW*" >/dev/null
then
	CLIENT_SUBJ="//CN=${REGISTRY_HOST}"
fi

####
# Fresh start
#### 
TEMP_CERT_PATH="${HOME}/docker_registry_certs"
rm -rf ${TEMP_CERT_PATH}
mkdir -p ${TEMP_CERT_PATH}

####
# * Generate the client private key
# * Generate signed certificate
# * Generate the client certificate
####
openssl req -subj "${CLIENT_SUBJ}" -newkey rsa:4096 -nodes -sha256 -CA ${HOME}/.docker/machine/certs/ca.pem -CAkey ${HOME}/.docker/machine/certs/ca-key.pem -keyout ${TEMP_CERT_PATH}/domain.pem -x509 -days 365 -out ${TEMP_CERT_PATH}/domain.crt

####
# * Remove unnecessary files
# * Copy the certificates to slave 
####
set +e
docker exec docker-registry rm -rf ${CERT_PATH}
docker cp ${TEMP_CERT_PATH} docker-registry:${CERT_PATH}
set -e

####
# * Copy the certificates to underlying host 
####
ssh -i ${HOME}/.docker/machine/machines/${MACHINE_NAME}/id_rsa "
sudo mkdir -p /etc/docker/certs.d/${REGISTRY_HOST}:5000/
cp /var/lib/docker/volumes/docker_registry_certs/* /etc/docker/certs.d/${REGISTRY_HOST}:5000/
"
