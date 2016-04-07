#!/bin/bash -e

####
# Windows Git bash terminal identifies 
# /CN=client as a path and appends the absolute path 
# of parent directory to it
####
HOST_OS=$(uname)
SERVER_SUBJ="/CN=adop"
if echo "${HOST_OS}" | grep -E "MINGW*" >/dev/null
then
	SERVER_SUBJ="//CN=adop"
fi

mkdir -p selfsigned/
cd selfsigned/
openssl genrsa -out adop-cert-key.pem 2048
openssl req -sha256 -new -key adop-cert-key.pem -out adop-csr.pem -subj "${SERVER_SUBJ}"
openssl x509 -req -days 365 -in adop-csr.pem -signkey adop-cert-key.pem -out adop-cert.pem
