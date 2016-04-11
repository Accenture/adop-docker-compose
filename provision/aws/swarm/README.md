# AWS Docker cluster using Swarm

A CloudFormation template to build a CentOS-based Docker cluster on AWS using Swarm.

## Parameters

The CloudFormation template takes the following parameters:

| Parameter | Description |
|-----------|-------------|
| SwarmNodeInstanceType | Swarm Node EC2 HVM instance type (t2.medium, m3.medium etc). |
| NATInstanceType | NAT EC2 HVM instance type (t2.small, m3.medium, etc). |
| SwarmClusterSize | Number of nodes in the Swarm cluster (3-12). The Actual size of the cluster is (SwarmClusterSize + 1) due to additional ADOP reverse proxy node created in the swarm cluster.|
| OuterProxyClusterSize | Number of nodes in the Outer Proxy cluster (1-12). |
| SwarmDiscoveryURL | A unique etcd cluster discovery URL. Grab a new token from https://discovery.etcd.io/new?size=5 |
| WhitelistAddress | The net block (CIDR) from which SSH to the proxy, swarm nodes and NAT instances is available. The public load balancer access is also restricted to same CIDR block. By default (0.0.0.0/0) allows access from everywhere. |
| KeyName | The name of an EC2 Key Pair to allow SSH access to the ec2 instances in the stack. |
| VpcAvailabilityZones | Comma-delimited list of three VPC availability zones in which to create subnets. This would work in the region with three AZ's.|

The template builds a new VPC with 3 subnets (in 3 availability zones) for proxy, 3 subnets (in 3 availability zones) for public ELB 
and  3 subnets (in 3 availability zones) for a single Swarm master, a cluster of between 3 and 12 nodes and
one dedicated instance for adop reverse proxy, using the standard AWS CentOS AMI.

Swarm hosts are evenly distributed across the 3 availability zones and are created
within an auto-scaling group which can be manually adjusted to alter
the Swarm cluster size post-launch.

A 'docker-swarm' container is run on each swarm host (the Swarm master and the nodes).
Hosts listen on port 4243, leaving the standard docker port (2375)
free for use by the 'docker-swarm' container on the master.

Separate 'master' and 'node' security groups control access between the nodes.
The template builds the Swarm master first, then the auto-scaling group
for the nodes
(each of which needs to register with the master via its 'docker-swarm'
container).

## Outputs

| Output | Description |
|--------|-------------|
| ELBPublicDNSURL | Public URL to access the ADOP stack |
| ELBPublicDNSName | DNS name of the public load balancer |
| ADOPReverseProxy | Private URL to access the ADOP stack |


## Using template

- This cloud formation template uses SSL certificate for ELB. It expects the ARN of the certificate as one of the input parameter.
	- The ssl certificate can be generated and/or uploaded to AWS. To generate and upload a new certificate follow the instructions from ([here](https://github.com/Accenture/adop-docker-compose/tree/master/provision/aws/ssl))
- Spin up a AWS cloudformation stack using the `CF-ADOP-Cluster.json` file in this directory. Once the stack is created move on to deploying the ADOP on the swarm cluster.
- Run : ssh -i \<KeyName\> centos@`ELBPublicDNSName` 
	- You can get the `ELBPublicDNSName` from cloudformation outputs as mentioned in above section. Outer proxy server acts as a bastion host.
	- KeyName is the private key selected from the drop down list while creating the stack.
- Clone ([this repository](https://github.com/Accenture/adop-docker-compose))
- Run: export DOCKER\_HOST=tcp://IP\_OF\_SWARM\_MASTER\_HOST:2375
	- You can get the IP\_OF\_SWARM\_MASTER\_HOST by searching for the instance with tag `STACK_NAME`-Master
- Run: export TARGET\_HOST=\<ELBPublicDNSName\>
	- You can get the `ELBPublicDNSName` from cloudformation outputs as mentioned in above section. 
- Run: export CUSTOM\_NETWORK\_NAME=\<CUSTOM\_NETWORK\_NAME\>
- Create a custom network: docker network create $CUSTOM\_NETWORK\_NAME
- Run: docker-compose -f compose/elk.yml up -d
- Run: export LOGSTASH\_HOST=\<IP\_OF\_NGINX\_HOST\>
	- You can get the IP\_OF\_NGINX\_HOST by searching for the instance with tag `STACK_NAME`-Nginx
- Run: source credentials.generate.sh \[This creates a file containing your generated passwords, platform.secrets.sh, which is sourced. If the file already exists, it will not be created.\]
    - platform.secrets.sh should not be uploaded to a remote repository hence **do not remove this file from the .gitignore file**
- Run: source env.config.sh
    - **If you delete platform.secrets.sh or if you edit any of the variables manually, you will need to re-run credentials.generate.sh in order to recreate the file or re-source the variables.**
    - **If you change the values in platform.secrets.sh, you will need to remove your existing docker containers and re-run docker-compose in order to re-create the containers with the new password values.**
    - **When creating a new instance of ADOP, you must delete platform.secrets.sh and regenerate it using credentials.generate.sh, else your old environment variables will get sourced as opposed to the new ones.**
- Run: export PROTO="https"
- Choose a volume driver - either "local" or "nfs" are provided, and if the latter is chosen then an NFS server is expected along with the NFS\_HOST environment variable
- Pull the images first (this is because we can't set dependencies in Compose yet so we want everything to start at the same time): docker-compose pull
- Run (logging driver file optional): docker-compose -f docker-compose.yml -f etc/volumes/\<VOLUME_DRIVER\>/default.yml -f etc/logging/syslog/default.yml up -d 

## Future work

* Persistent storge - no, there isn't any currently!

