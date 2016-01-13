# Temporary Getting Started Instructions

These instructions are only required until the data deployment and init steps have been integrated into the main Docker image.

- [OPTIONAL] Create a Docker Engine in AWS: docker-machine create --driver amazonec2 --amazonec2-access-key YOUR\_ACCESS\_KEY --amazonec2-secret-key YOUR\_SECRET\_KEY --amazonec2-vpc-id vpc-27d43742 --amazonec2-instance-type t2.large --amazonec2-region eu-west-1 YOUR\_MACHINE\_NAME
- Set any required environment variables
- Transfer "volumes/nginx-configuration-vol" and "volumes/nginx-releasenote-vol" directories to the target host location - without this Nginx will not start
- Create a custom network: docker network create <CUSTOM_NETWORK_NAME>
- Choose a volume driver - either "local" or "nfs" are provided, and if the latter is chosen then an NFS server is expected along with the NFS_HOST environment variable
- Run: docker-compose -f docker-compose-no-init.yml -f etc/volumes/<VOLUME_DRIVER>/default.yml up -d
- Run from compose host: docker exec gerrit bash -c '/var/gerrit/adop\_scripts/create\_user.sh -u gerrit -p gerrit && /var/gerrit/adop\_scripts/create\_user.sh -u jenkins -p jenkins && /var/gerrit/adop\_scripts/create\_user.sh -u john.smith -p Password01 && /var/gerrit/adop\_scripts/add\_user\_to\_group.sh -A gerrit -P gerrit -u jenkins -g "Non-Interactive Users" && /var/gerrit/adop\_scripts/add\_user\_to\_group.sh -A gerrit -P gerrit -u john.smith -g Administrators'
- Restart everything once the previous steps have been carried out so that Nginx, Gerrit, and Jenkins start correctly - this is mostly to make sure they work properly against LDAP

# Required environment variable on the host

- TARGET_HOST the dns/ip of proxy
- LAGSTASH_HOST the dns/ip of logstash
- CUSTOM_NETWORK_NAME: The name of the pre-created custom network to use
- [OPTIONAL] NFS_HOST: The DNS/IP of your NFS server

# Temporary define default index pattern

As described on [this|https://alm.accenture.com/jira/browse/DA-1359?focusedCommentId=132808&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-132808] comment, Kibana 4 does not provide a configuration property that allow to define the default index pattern for this reason while issue [DA-1401|https://alm.accenture.com/jira/browse/DA-1401] is prioritized the following manual procedure should be adopted in order to define an index pattern:

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
