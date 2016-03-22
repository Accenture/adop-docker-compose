[![Build Status](https://travis-ci.org/Accenture/adop-docker-compose.svg?branch=master)](https://travis-ci.org/Accenture/adop-docker-compose)

# The DevOps Platform: Overview

The DevOps Platform is a tools environment for continuously testing, releasing and maintaining applications. Reference code, delivery pipelines, automated testing and environments can be loaded in via the concept of Cartridges.

![HomePage](https://raw.githubusercontent.com/accenture/adop-docker-compose/master/img/home.png)

Once you have a stack up and running, please log in with the username and password created upon startup.

# Quickstart instructions

These instructions will spin up an instance in a single server in AWS (for evaluation purposes).

1. Create a VPC using the [VPC wizard](http://docs.aws.amazon.com/AmazonVPC/latest/GettingStartedGuide/getting-started-create-vpc.html) in the AWS console by selecting the first option with 1 public subnet
1. Note the VPC ID (e.g. vpc-1ed3sfgw)
1. Clone this repository and then in a terminal window (this has been tested in GitBash) run:
```bash
$ ./startup.sh
Usage: ./startup.sh -m <MACHINE_NAME>  
                    -c <VPC_ID> 
                    -r <REGION>(optional) 
                    -a <AWS_ACCESS_KEY>(optional) 
                    -s <AWS_SECRET_ACCESS_EY>(optional) 
                    -v <VOLUME_DRIVER>(optional) 
                    -n <CUSTOM_NETWORK_NAME>(optional) 
                    -l LOGGING_DRIVER(optional) 
                    -f path/to/additional_override1.yml(optional) 
                    -f path/to/additional_override2.yml(optional) 
                    -u <ADMIN_USER>
                    -p <PASSWORD>(optional) ...
```
* You will need to supply:
    - a machine name (anything you want)
    - the target VPC
    - If you don't have your AWS credentials and default region [stored locally in ~/.aws](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-config-files) you will also need to supply:
        - your AWS key and your secret access key (see [getting your AWS access key](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)) via command line options, environment variables or using aws configure 
        - the AWS region id in this format: eu-west-1
    - a username and password to act as credentials for the initial admin user

For example (if you don't have ~/.aws set up)
```bash
./startup.sh -m adop1 -a AAA -s BBB -c vpc-123abc -r eu-west-1 -u user.name -p userPassword
```
4. If all goes well you will see the following output and you can view the DevOps Platform in your browser
```bash
##########################################################

SUCCESS, your new ADOP instance is ready!

Run these commands in your shell:
  eval \"$(docker-machine env $MACHINE_NAME)\"
  source env.config.sh

Navigate to http://11.22.33.44 in your browser to use your new DevOps Platform!
```
5. Log in using the username and password you created in the startup script:
```sh
<ADMIN_USER>/ <PASSWORD>
```


# General Getting Started Instructions

The platform is designed to run on any container platform. 

## To run in AWS (single instance) manually

- Create a VPC using the VPC wizard in the AWS console by selecting the first option with 1 public subnet

- Create a Docker Engine in AWS: 
```sh
docker-machine create --driver amazonec2 --amazonec2-access-key YOUR\_ACCESS\_KEY --amazonec2-secret-key YOUR\_SECRET\_KEY --amazonec2-vpc-id vpc-YOUR_ID --amazonec2-instance-type t2.large --amazonec2-region REGION IN THIS FORMAT: eu-west-1   YOUR\_MACHINE\_NAME
```

- Update the docker-machine security group to permit inbound http traffic on port 80 (from the machine(s) from which you want to have access only), also UDP on 25826 and 12201 from 127.0.0.1/32

- Set your local environment variables to point docker-machine to your new instance

## To run locally
Create a docker machine and set up your local environment variables to point docker-machine to your new instance

## To run with Docker Swarm

Create a Docker Swarm that has a publicly accessible Engine with the label "tier=public" to bind Nginx and Logstash to that node

## Launching

- Run: export TARGET\_HOST=\<IP\_OF\_PUBLIC\_HOST\>
- Run: export CUSTOM\_NETWORK\_NAME=\<CUSTOM\_NETWORK\_NAME\>
- Create a custom network: docker network create $CUSTOM\_NETWORK\_NAME
- Run: docker-compose -f compose/elk.yml up -d
- Run: export LOGSTASH\_HOST=\<IP\_OF\_LOGSTASH\_HOST\>
- Run: source credentials.config.sh **\[Note: Only run this script once or else new credentials will be generated and you will not have access to the tools.\]**
- Run: source env.config.sh
- Choose a volume driver - either "local" or "nfs" are provided, and if the latter is chosen then an NFS server is expected along with the NFS\_HOST environment variable
- Pull the images first (this is because we can't set dependencies in Compose yet so we want everything to start at the same time): docker-compose pull
- Run (logging driver file optional): docker-compose -f docker-compose.yml -f etc/volumes/\<VOLUME_DRIVER\>/default.yml -f etc/logging/syslog/default.yml up -d

# Required environment variable on the host

- MACHINE_NAME the name of your docker machine
- TARGET\_HOST the dns/ip of proxy
- LOGSTASH\_HOST the dns/ip of logstash
- CUSTOM\_NETWORK\_NAME: The name of the pre-created custom network to use
- [OPTIONAL] NFS\_HOST: The DNS/IP of your NFS server

# Using the platform 

###### Generate ssl certificate

Create ssl certificate for jenkins to allow connectivity with docker engine.

* RUN : source env.config.sh
* RUN : ./generate\_client\_certs.sh ${DOCKER\_CLIENT\_CERT\_PATH}

Note : For windows run the generate\_client\_certs.sh script from a terminal (Git Bash) as administrator.

###### Load Platform

* Access the target host url `http://<TARGET_HOST>` with the your username and password
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

# Define Default Elastic Search Index Pattern

Kibana 4 does not provide a configuration property that allow to define the default index pattern so the following manual procedure should be adopted in order to define an index pattern:

- Navidate to Settings > Indices using Kibana dashboard
- Set index name or pattern as "logstash-*"
- For the below drop-down select @timestamp for the Time-field name
- Click on create button

# User feedback

## Documentation
Documentation can be found under the [`docker-library/docs` GitHub repo](https://github.com/docker-library/docs). Be sure to familiarize yourself with the [repository's `README.md` file](https://github.com/docker-library/docs/blob/master/README.md) before attempting a pull request.

## Issues
If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/Accenture/adop-docker-compose/issues).

## Contribute
You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/Accenture/adop-docker-compose/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.


