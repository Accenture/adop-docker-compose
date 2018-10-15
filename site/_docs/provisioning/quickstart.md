---
layout: docs
chapter: Provisioning
title: Using the quickstart script 
permalink: /docs/provisioning/quickstart
---

# Quickstart Instructions

These instructions will spin up an instance in a single server in AWS (for evaluation purposes).  Please check the [prerequisites](http://accenture.github.io/adop-docker-compose/docs/prerequisites/).

NB. the instructions will also work in anywhere supported by [Docker Machine](https://docs.docker.com/machine/), just follow the relevant Docker Machine instructions for your target platform and then start at step 3 below and (you can set the AWS_VPC_ID to NA).

1. Create a VPC using the [VPC wizard](http://docs.aws.amazon.com/AmazonVPC/latest/GettingStartedGuide/getting-started-create-vpc.html) in the AWS console by selecting the first option with 1 public subnet.
2. On the "Step 2: VPC with a Single Public Subnet" page give your VPC a meaningful name and specify the availability zone as 'a', e.g. select eu-west-1a from the pulldown.
3. Once the VPC is created note the VPC ID (e.g. vpc-1ed3sfgw)
4. Clone this repository and then in a terminal window (this has been tested in GitBash):
    - Run:

        ```./quickstart.sh ```
        ```bash
        $ ./quickstart.sh
        Usage: ./quickstart.sh -t aws
                               -m <MACHINE_NAME>  
                               -c <AWS_VPC_ID> 
                               -r <AWS_DEFAULT_REGION> 
                               -z <VPC_AVAIL_ZONE>(optional)
                               -a <AWS_ACCESS_KEY>(optional) 
                               -s <AWS_SECRET_ACCESS_EY>(optional) 
                               -u <INITIAL_ADMIN_USER>
                               -p <INITIAL_ADMIN_PASSWORD>(optional) ...
        ```
        - You will need to supply:
            - the type of machine to create (aws, in this example)
            - a machine name (anything you want)
            - the target VPC
            - If you don't have your AWS credentials and default region [stored locally in ~/.aws](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-config-files) you will also need to supply:
                - your AWS key and your secret access key (see [getting your AWS access key](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)) via command line options, environment variables or using aws configure 
                - the AWS region id in this format: eu-west-1
            - a username and password (optional) to act as credentials for the initial admin user (you will be prompted to re-enter your password if it is considered weak)
                - The initial admin username cannot be set to 'admin' to avoid duplicate entries in LDAP.
            - AWS parameters i.e. a subnet ID, the name of a keypair and an EC2 instance type (these parameters are useful if you would like to extend the platform with additional AWS EC2 services)
    - For example (if you don't have ~/.aws set up):

        ```./quickstart.sh -t aws -m adop1 -a AAA -s BBB -c vpc-123abc -r eu-west-1 -u user.name -p userPassword```
        - N.B. If you see an error saying that docker-machine cannot find an associated subnet in a zone, go back to the VPC Dashboard on AWS and check the availablity zone for the subnet you've created. Then rerun the startup script and use the -z option to specify the zone for your subnet, e.g. for a zone of eu-west-1c the above command becomes:

            ```./quickstart.sh -t aws -m adop1 -a AAA -s BBB -c vpc-123abc -r eu-west-1 -u user.name -p userPassword -z c```
5. If all goes well you will see the following output and you can view the DevOps Platform in your browser
    ```
    ##########################################################

    SUCCESS, your new ADOP instance is ready!

    Run this command in your shell:
      source ./conf/env.provider.sh
      source credentials.generate.sh
      source env.config.sh
      
    You can check if any variables are missing with: ./adop compose config  | grep 'WARNING'

    Navigate to http://<PROXY IP> in your browser to use your new DevOps Platform!
    Login using the following credentials:
      Username: YOUR_USERNAME
      Password: YOUR_PASSWORD
    ```
6. Log in using the username and password you specified in the quickstart script:
    ```<INITIAL_ADMIN_USER> / <INITIAL_ADMIN_PASSWORD>```

7. Update the docker-machine security group in the AWS console to permit inbound http traffic on port 80 (from the machine(s) from which you want to have access only), also UDP on 25826 and 12201 from 127.0.0.1/32.

