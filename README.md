# Temporary Getting Started Instructions


- [OPTIONAL] Create a Docker Engine in AWS: docker-machine create --driver amazonec2 --amazonec2-access-key YOUR\_ACCESS\_KEY --amazonec2-secret-key YOUR\_SECRET\_KEY --amazonec2-vpc-id vpc-27d43742 --amazonec2-instance-type t2.large --amazonec2-region eu-west-1 YOUR\_MACHINE\_NAME
- Run: export TARGET\_HOST=\<IP\_OF\_PUBLIC\_HOST\>
- Create a custom network: docker network create \<CUSTOM\_NETWORK\_NAME\>
- Run: export CUSTOM\_NETWORK\_NAME=\<CUSTOM\_NETWORK\_NAME\>
- Run: docker-compose -f compose/elk.yml up -d
- Run: export LOGSTASH\_HOST=\<IP\_OF\_LOGSTASH\_HOST\>
- Choose a volume driver - either "local" or "nfs" are provided, and if the latter is chosen then an NFS server is expected along with the NFS\_HOST environment variable
- Pull the images first (this is because we can't set dependencies in Compose yet so we want everything to start at the same time): docker-compose pull
- Run (logging driver file optional): docker-compose -f docker-compose.yml -f etc/volumes/\<VOLUME_DRIVER\>/default.yml -f etc/logging/syslog/default.yml up -d

# Required environment variable on the host

- TARGET\_HOST the dns/ip of proxy
- LOGSTASH\_HOST the dns/ip of logstash
- CUSTOM\_NETWORK\_NAME: The name of the pre-created custom network to use
- [OPTIONAL] NFS_HOST: The DNS/IP of your NFS server

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
