#!/bin/bash -e

CERT_PATH=$1
echo ${CERT_PATH}
if [ -z ${CERT_PATH} ]; then
    echo "
	  Usage : 
		$0 <docker_client_certificate_path>
	  
	  <docker_client_certificate_path>: 
		This is the path of the certificate on jenkins slave container
		to be able to run docker commands against docker swarm.
		Note - absolute path is required.
    	  
	  Example: 
		$0 /root/.docker
    "
    exit 1
fi

####
# Windows Git bash terminal identifies 
# /CN=client as a path and appends the absolute path 
# of parent directory to it
####
HOST_OS=$(uname)
CLIENT_SUBJ="/CN=client"
if echo "${HOST_OS}" | grep -E "MINGW*" >/dev/null
then
	CLIENT_SUBJ="//CN=client"
fi

####
# Fresh start
#### 
TEMP_CERT_PATH="${HOME}/docker_certs"
rm -rf ${TEMP_CERT_PATH}
mkdir -p ${TEMP_CERT_PATH}

####
# * Generate the client private key
# * Generate signed certificate
# * Generate the client certificate
####
openssl genrsa -out ${TEMP_CERT_PATH}/key.pem 4096
openssl req -subj "${CLIENT_SUBJ}" -new -key ${TEMP_CERT_PATH}/key.pem -out ${TEMP_CERT_PATH}/client.csr
echo "extendedKeyUsage = clientAuth" >  ${TEMP_CERT_PATH}/extfile.cnf
openssl x509 -req -days 365 -sha256 -in ${TEMP_CERT_PATH}/client.csr -CA ${HOME}/.docker/machine/certs/ca.pem -CAkey ${HOME}/.docker/machine/certs/ca-key.pem -CAcreateserial -out ${TEMP_CERT_PATH}/cert.pem -extfile ${TEMP_CERT_PATH}/extfile.cnf
cp ${HOME}/.docker/machine/certs/ca.pem ${TEMP_CERT_PATH}/ca.pem
docker --tlsverify --tlscacert=${HOME}/.docker/machine/certs/ca.pem --tlscert=${TEMP_CERT_PATH}/cert.pem --tlskey=${TEMP_CERT_PATH}/key.pem -H=${DOCKER_HOST} version

####
# * Remove unnecessary files
# * Copy the certificates to slave 
####
rm -f ${TEMP_CERT_PATH}/extfile.cnf ${TEMP_CERT_PATH}/client.csr
set +e
docker exec jenkins-slave rm -rf ${CERT_PATH}
docker cp ${TEMP_CERT_PATH} jenkins-slave:${CERT_PATH}
set -e

