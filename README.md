# Temporary Getting Started Instructions

## To run in AWS (single instance)

- Create a VPC using the VPC wizard in the AWS console by selecting the first option with 1 public subnet

- Create a Docker Engine in AWS: 

docker-machine create --driver amazonec2 --amazonec2-access-key YOUR\_ACCESS\_KEY --amazonec2-secret-key YOUR\_SECRET\_KEY --amazonec2-vpc-id vpc-YOUR_ID --amazonec2-instance-type t2.large --amazonec2-region REGION IN THIS FORMAT: eu-west-1   YOUR\_MACHINE\_NAME

- Update the docker-machine security group to permit inbound http traffic on port 80 (from the machine(s) from which you want to have access only), and TCP on 2376, UDP on 25826, and UDP on 12201 (from 127.0.0.1/32)

- Set your local environment variables to point docker-machine to your new instance

## To run locally
Create a docker machine and set up you local environment variables to point docker-machine to your new instance

## Launching
- TODO:REMOVE this line - log on to docker.accenture.com

- Run: export TARGET\_HOST=\<IP\_OF\_PUBLIC\_HOST\>
- Run: export CUSTOM\_NETWORK\_NAME=\<CUSTOM\_NETWORK\_NAME\>
- Create a custom network: docker network create $CUSTOM\_NETWORK\_NAME
- Run: docker-compose -f compose/elk.yml up -d
- Run: export LOGSTASH\_HOST=\<IP\_OF\_LOGSTASH\_HOST\>
- Run: source env.config.sh
- Choose a volume driver - either "local" or "nfs" are provided, and if the latter is chosen then an NFS server is expected along with the NFS\_HOST environment variable
- Pull the images first (this is because we can't set dependencies in Compose yet so we want everything to start at the same time): docker-compose pull
- Run (logging driver file optional): docker-compose -f docker-compose.yml -f etc/volumes/\<VOLUME_DRIVER\>/default.yml -f etc/logging/syslog/default.yml up -d

# Required environment variable on the host

- TARGET\_HOST the dns/ip of proxy
- LOGSTASH\_HOST the dns/ip of logstash
- CUSTOM\_NETWORK\_NAME: The name of the pre-created custom network to use
- [OPTIONAL] NFS_HOST: The DNS/IP of your NFS server

# Using the paltform 

* Access the target host url `http://<TARGET_HOST>`
 * This page presents the links to all the tools.
* Click: Jenkins link.
* Run: Load\_Platform job
 * Once the Load\_Platform job and other downstream jobs are finished your platform is ready to be used.
 * This job generates a example workspace folder, example project folder and jenkins jobs/pipelines for java reference application.
* Create environment to deploy the reference application
 * Navigate to `http://<TARGET_HOST>/jenkins/job/ExampleWorkspace/job/ExampleProject/job/Create_Environment`
 * Build with Parameters keeping the default value.
* Run Example pipeline
 * Navigate to `http://<TARGET_HOST>/jenkins/job/ExampleWorkspace/job/ExampleProject/view/Java_Reference_Application/`
 * Click on run.
* Browse the environment
 * Click on the url for your environment from deploy job.
 * You should be able to see the spring petclinic application.
* Now, you can clone the repository from gerrit and make a code change to see the example pipeline triggered automatically.

# Temporary define default index pattern

As described on https://alm.accenture.com/jira/browse/DA-1359?focusedCommentId=132808&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-132808 comment, Kibana 4 does not provide a configuration property that allow to define the default index pattern for this reason while issue [DA-1401|https://alm.accenture.com/jira/browse/DA-1401] is prioritized the following manual procedure should be adopted in order to define an index pattern:

- Navidate to Settings > Indices using Kibana dashboard
- Set index name or pattern as "logstash-*"
- For the below drop-down select @timestamp for the Time-field name
- Click on create button

# Status

This is still WIP and does not work full yet.

# Assumes a directory structure of

BASE/adop

BASE/images/*all the image repos*
-  docker-gerrit
-  docker-jenkins
-  docker-ldap
-  docker-nginx
-  docker-sonar

BASE/volumes
