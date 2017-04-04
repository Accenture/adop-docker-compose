# ADOP AWS SSL setup 

Scripts in this directory provides a way to generate the self signed certificate and upload it .


## Using the scripts for self signed certificates.

* Run create_certs.sh script. This script generates the self signed certificates.
* Setup AWS credentials before uploading the certificates to AWS.
 * Run export AWS_DEFAULT_REGION=eu-west-1
 * Run export AWS_DEFAULT_OUTPUT_FORMAT=text
 * Run export AWS_ACCESS_KEY_ID=\<aws secret key\>
 * Run export AWS_SECRET_ACCESS_KEY=\<aws access key\> 
 * Run upload_certs.sh script. 
* Upload script generates ARN to which can be used to access the uploaded self signed certificate. This ARN is passed as a input parameter to ELBs performing SSL termination. 

## Using the scripts for trusted certificates.
TODO
