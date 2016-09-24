# AWS Docker cluster using Swarm

A CloudFormation template to build a CentOS-based Docker cluster on AWS using docker swarm.

## Parameters

The CloudFormation template takes the following parameters:

| Parameter | Description |
|-----------|-------------|
| SwarmNodeInstanceType | Swarm Node EC2 HVM instance type (t2.medium, m3.medium etc). |
| NATInstanceType | NAT EC2 HVM instance type (t2.small, m3.medium, etc). |
| SwarmClusterSize | Number of nodes in the Swarm cluster (3-12). The Actual size of the cluster is (SwarmClusterSize + 1) due to additional ADOP reverse proxy node created in the swarm cluster.|
| OuterProxyClusterSize | Number of nodes in the Outer Proxy cluster (1-12). |
| SwarmDiscoveryURL | A unique etcd cluster discovery URL. Grab a new token from https://discovery.etcd.io/new?size=1 |
| WhitelistAddress | The net block (CIDR) from which SSH to the proxy, swarm nodes and NAT instances is available. The public load balancer access is also restricted to same CIDR block. By default (0.0.0.0/0) allows access from everywhere. |
| KeyName | The name of an EC2 Key Pair to allow SSH access to the ec2 instances in the stack. |
| VpcAvailabilityZones | Comma-delimited list of three VPC availability zones in which to create subnets. This would work in the region with three AZ's.|
| SSLCertificateARN | The AWS SSL Certificate ARN to enable ssl.|

The template builds a new VPC with 3 subnets (in 3 availability zones) for proxy, 3 subnets (in 3 availability zones) for public ELB and  3 subnets (in 3 availability zones) for a single Swarm master, a cluster of between 3 and 12 nodes and one dedicated instance for adop reverse proxy, using the standard AWS CentOS AMI.

Swarm hosts are evenly distributed across the 3 availability zones and are created within an auto-scaling group which can be manually adjusted to alter the Swarm cluster size post-launch.

A 'docker-swarm' container is run on each swarm host (the Swarm master and the nodes). Hosts listen on port 4243, leaving the standard docker port (2375) free for use by the 'docker-swarm' container on the master.

Separate 'master' and 'node' security groups control access between the nodes. The template builds the Swarm master first, then the auto-scaling group for the nodes.

## Outputs

| Output | Description |
|--------|-------------|
| ELBPublicDNSURL | Public URL to access the ADOP stack |
| ELBPublicDNSName | DNS name of the public load balancer |
| ADOPReverseProxy | Private URL to access the ADOP stack |
| SwarmMasterIP | Private IP Address of the swarm master server |


## Using template

- This cloud formation template uses SSL certificate for ELB. It expects the ARN of the certificate as one of the input parameter.
	- The ssl certificate can be generated and/or uploaded to AWS. To generate and upload a new certificate follow the instructions from ([here](https://github.com/Accenture/adop-docker-compose/tree/master/provision/aws/ssl))
- Spin up a AWS cloudformation stack using the `CF-ADOP-Cluster.json` file in this directory. Once the stack is created move on to deploying the ADOP on the swarm cluster.
- Run : ssh -i \<KeyName\> centos@`ELBPublicDNSName` 
	- You can get the `ELBPublicDNSName` from cloudformation outputs as mentioned in above section. Outer proxy server acts as a bastion host.
	- KeyName is the private key selected from the drop down list while creating the stack.
- Clone ([this repository](https://github.com/Accenture/adop-docker-compose))
- Run: export DOCKER\_HOST=tcp://\<SwarmMasterIP\>:2375
	- You can get the `SwarmMasterIP` from cloudformation outputs as mentioned in above section.
- Run: export TARGET\_HOST=\<ELBPublicDNSName\>
	- You can get the `ELBPublicDNSName` from cloudformation outputs as mentioned in above section. 
- Optionally Run: export CUSTOM\_NETWORK\_NAME=\<CUSTOM\_NETWORK\_NAME\>
	- By default the custom docker network is created with name `local_network`
- Run: ./adop compose init
	- This command will prompt you to set the admin user name and generates a random password for admin use. If you want to have a predefined admin username and credentials for your adop stack then set the following variables -
		- export INITIAL_ADMIN_USER=\<your admin username\>
		- export INITIAL_ADMIN_PASSWORD_PLAIN=\<your admin password\>

## Future work

* Persistent storge - no, there isn't any currently!

