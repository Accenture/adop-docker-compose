---
layout: docs
title: Quickstart
permalink: /docs/quickstart/
---

These instructions will spin up an instance in a single server in AWS (for evaluation purposes). Please check the [prerequisites](/adop-docker-compose/docs/prerequisites/).

NB. the instructions will also work in anywhere supported by [Docker Machine](https://docs.docker.com/machine/), just follow the relevant Docker Machine instructions for your target platform and then start at step 3 below and (you can set the VPC_ID to NA).

1. Create a VPC using the [VPC wizard](http://docs.aws.amazon.com/AmazonVPC/latest/GettingStartedGuide/getting-started-create-vpc.html) in the AWS console by selecting the first option with 1 public subnet.
1. On the "Step 2: VPC with a Single Public Subnet" page give your VPC a meaningful name and specify the availability zone as 'a', e.g. select eu-west-1a from the pulldown.
1. Once the VPC is created note the VPC ID (e.g. vpc-1ed3sfgw)
1. Clone this repository [adop-docker-compose](https://github.com/Accenture/adop-docker-compose) and then in a terminal window (this has been tested in GitBash):
    - Run:

        ```./quickstart.sh ```

        ```bash
        $ ./quickstart.sh
        Usage: ./quickstart.sh -t aws
                               -m <MACHINE_NAME>  
                               -c <VPC_ID> 
                               -r <REGION>(optional) 
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

    - For example (if you don't have ~/.aws set up):

        ```./quickstart.sh -t aws -m adop1 -a AAA -s BBB -c vpc-123abc -r eu-west-1 -u user.name -p userPassword```

        - N.B. If you see an error saying that docker-machine cannot find an associated subnet in a zone, go back to the VPC Dashboard on AWS and check the availablity zone for the subnet you've created. Then rerun the startup script and use the -z option to specify the zone for your subnet, e.g. for a zone of eu-west-1c the above command becomes:

            ```./quickstart.sh -t aws -m adop1 -a AAA -s BBB -c vpc-123abc -r eu-west-1 -u user.name -p userPassword -z c```

1. If all goes well you will see the following output and you can view the DevOps Platform in your browser using the link that accompanies this output:

    ```SUCCESS, your new ADOP instance is ready!```

1. Log in using the username and password you specified in the quickstart script.
    - These can also be found in your "platform.secrets.sh" file

1. Update the docker-machine security group in the AWS console to permit inbound http traffic on ports 80 and 443 (from the machine(s) from which you want to have access only), also UDP on 25826 and 12201 from 127.0.0.1/32.
