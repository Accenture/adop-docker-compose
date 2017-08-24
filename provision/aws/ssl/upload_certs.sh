#!/bin/bash -e

usage() {
    echo "
	  Usage : 
		$0 -n <AWS_CERTIFICATE_NAME> -k <PATH_TO_CERTIFICATE_KEY> -c <PATH_TO_CERTIFICATE> -e <CA_CERTIFICATE_PATH>
	  
	  	-n <AWS_CERTIFICATE_NAME>: [OPTIONAL] This is the name of the certificate used to upload it to AWS. Note : This has to be unique for an AWS account.
   	  	-k <PATH_TO_CERTIFICATE_KEY> : [OPTIONAL] This is the parameter to provide the path of the certificate key file.
   	  	-c <PATH_TO_CERTIFICATE> : [OPTIONAL] This is the parameter to provide the path of the certificate key file.
   	  	-e <CA_CERTIFICATE_PATH> : [OPTIONAL] This is the parameter to provide the path of the CA certificate file. 
   	  							   If this switch is not specified then self signed certificates are used.

	  Examples: 
	  	1) Generate and Upload Self Signed certificate.
			$0 -n adop-selfsigned-cert -k file://selfsigned/adop-cert-key.pem -c file://selfsigned/adop-cert.pem 
		2) Upload custom certificate.
			$0 -n adop-selfsigned-cert -k file://custom/adop-cert-key.pem -c file://custom/adop-cert.pem -e file://custom/ca-cert.pem
    "
    exit 1	
}

export SELF_SIGNED_CERT=1
export CERT_KEY='file://selfsigned/adop-cert-key.pem'
export CERT='file://selfsigned/adop-cert.pem'
export CERT_NAME='adop-selfsigned-cert'

while getopts "n:k:c:e:" opt; do
  case $opt in
    e)
      export SELF_SIGNED_CERT=0
      export CA_PATH=${OPTARG}
      ;;
    n)
      export CERT_NAME=${OPTARG}
      ;;
    k)
      export CERT_KEY=${OPTARG}
      ;;
    c)
      export CERT=${OPTARG}
      ;;
    \?)
      echo "Invalid parameter(s) or option(s)."
      usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ -z $CERT_NAME ] ; then
  usage
  exit 1
fi

if aws iam list-server-certificates --output text --query 'ServerCertificateMetadataList[*].[ServerCertificateName]' | grep "${CERT_NAME}" >/dev/null 2>&1
then
	echo "ERROR : Certificate ${CERT_NAME} already exists. Either use a different name or delete the existing one."
	echo "Command to delete certificate : aws iam delete-server-certificate --server-certificate-name ${CERT_NAME}"
	exit 1
fi


if [ ${SELF_SIGNED_CERT} -eq 0 ]; then
	CERT_ARN=$(aws iam upload-server-certificate --server-certificate-name ${CERT_NAME} \
				--certificate-body ${CERT} --private-key ${CERT_KEY} --certificate-chain ${CA_PATH} \
				--output text --query 'ServerCertificateMetadata.Arn')
else
	CERT_ARN=$(aws iam upload-server-certificate --server-certificate-name ${CERT_NAME} \
				--certificate-body ${CERT} --private-key ${CERT_KEY} \
				--output text --query 'ServerCertificateMetadata.Arn')
fi

echo "Certificate has been uploaded successfully. Use below ARN with an ELB to enable SSL."
echo "=================================="
echo "=========    ARN      ============"
echo "${CERT_ARN}"
echo "=================================="
echo "=================================="
