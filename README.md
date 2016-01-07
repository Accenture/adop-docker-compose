# Temporary Getting Started Instructions

These instructions are only required until the data deployment and init steps have been integrated into the main Docker image.

- [OPTIONAL] Create a Docker Engine in AWS: docker-machine create --driver amazonec2 --amazonec2-access-key YOUR\_ACCESS\_KEY --amazonec2-secret-key YOUR\_SECRET\_KEY --amazonec2-vpc-id vpc-27d43742 --amazonec2-instance-type t2.large --amazonec2-region eu-west-1 YOUR\_MACHINE\_NAME
- Use the "docker-compose-no-init.yml" compose file 
- Transfer "volumes/nginx-configuration-vol" and "volumes/nginx-releasenote-vol" directories to the target host location - without this Nginx will not start
- Run this on the target host from within the "volumes" directory: chown -R 1000:1000 gerrit-site-vol jenkins-home-vol git-repos-vol
- Run from compose host: docker exec dockercompose\_ldap\_1 bash -c '/usr/local/bin/load\_ldif.sh -h $(hostname) -u cn=admin,dc=adop,dc=accenture,dc=com -p Sw4syJSWQRx2AK6KE3vbhpmL -b dc=adop,dc=accenture,dc=com -f /tmp/structure.ldif'
- Run from compose host: docker exec dockercompose\_gerrit\_1 bash -c '/var/gerrit/adop\_scripts/create\_user.sh -u gerrit -p gerrit && /var/gerrit/adop\_scripts/create\_user.sh -u jenkins -p jenkins && /var/gerrit/adop\_scripts/create\_user.sh -u john.smith -p Password01 && /var/gerrit/adop\_scripts/add\_user\_to\_group.sh -A gerrit -P gerrit -u jenkins -g "Non-Interactive Users" && /var/gerrit/adop\_scripts/add\_user\_to\_group.sh -A gerrit -P gerrit -u john.smith -g Administrators'
- Restart everything once the previous steps have been carried out so that Nginx, Gerrit, and Jenkins start correctly

# Required environment variable on the host

- TARGET_HOST the dns/ip of proxy
- LAGSTASH_HOST the dns/ip of logstash

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
