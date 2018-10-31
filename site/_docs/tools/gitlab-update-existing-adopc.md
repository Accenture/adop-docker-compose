---
layout: docs
chapter: Tools
title: Updating existing ADOP/C with Gitlab
permalink: /docs/tools/gitlab-update-existing-adopc/
---

This page is to be able to deploy Gitlab in an existing running ADOP/C. Follow the below steps to replace Gerrit with Gitlab:

The overview of the process is:

* Add the Gitlab container alongside Gerrit
* Migrate repositories from Gerrit to Gitlab
* Deploy latest version of ADOP without Gerrit

Any Jenkins jobs that clone from Gerrit will have to be updated to point to Gitlab manually after this process has been completed.

## Instructions

1. Back up your ADOP data. For example, if running AWS you can snapshot your EBS volume
2. Log on to the machine/instance where your ADOP/C is running
3. Navigate to the adop-docker-compose directory

```
cd /data/adop-docker-compose
```

4. Add the following code snippet to the docker-compose.yml file. This will allow Gitlab to be launched alongside Gerrit. Refer [adop-docker-compose](https://github.com/Accenture/adop-docker-compose/blob/master/docker-compose.yml) repo for right parameters.

```
gitlab-postgresql:
  container_name: gitlab-postgresql
  restart: always
  image: postgres:9.6.9-alpine
  net: ${CUSTOM_NETWORK_NAME}
  expose:
    - "5432"
  environment:
    POSTGRES_USER: ${GITLAB_POSTGRES_USER}
    POSTGRES_PASSWORD: ${GITLAB_POSTGRES_PASSWORD}
    POSTGRES_DB: ${GITLAB_POSTGRES_DB}
 
gitlab:
  container_name: gitlab
  restart: always
  image: accenture/adop-gitlab:0.1.1
  hostname: gitlab
  links:
    - gitlab-postgresql:postgresql
    - gitlab-redis:redis
  net: ${CUSTOM_NETWORK_NAME}
  expose:
    - "80"
    - "22"
  environment:
    INITIAL_ADMIN_USER: ${INITIAL_ADMIN_USER}
    INITIAL_ADMIN_PASSWORD: ${INITIAL_ADMIN_PASSWORD_PLAIN}
    JENKINS_USER: ${GITLAB_JENKINS_USERNAME}
    JENKINS_PASSWORD: ${PASSWORD_JENKINS}
    GITLAB_OMNIBUS_CONFIG: |
     external_url "${PROTO}://${TARGET_HOST}/gitlab"
     postgresql['enable'] = false
     gitlab_rails['db_username'] = "${GITLAB_POSTGRES_USER}"
     gitlab_rails['db_password'] = "${GITLAB_POSTGRES_PASSWORD}"
     gitlab_rails['db_host'] = "gitlab-postgresql"
     gitlab_rails['db_port'] = "5432"
     gitlab_rails['db_database'] = "${GITLAB_POSTGRES_DB}"
     gitlab_rails['db_adapter'] = 'postgresql'
     gitlab_rails['db_encoding'] = 'utf8'
     gitlab_rails['monitoring_whitelist'] = ['127.0.0.0/8', '172.0.0.0/8']
     # Redis Configuration
     redis['enable'] = false
     gitlab_rails['redis_host'] = 'gitlab-redis'
     gitlab_rails['redis_port'] = '6379'
     # LDAP Configuration
     gitlab_rails['ldap_enabled'] = true
     gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
       main:
         label: 'LDAP'
         host: 'ldap'
         port: 389
         uid: 'uid'
         method: 'plain'
         bind_dn: '${LDAP_MANAGER_DN}'
         password: '${LDAP_PWD}'
         active_directory: true
         allow_username_or_email_login: false
         block_auto_created_users: false
         base: '${LDAP_FULL_DOMAIN}'
         signin_enabled: false
     EOS
 
gitlab-redis:
  container_name: gitlab-redis
  restart: always
  image: redis:3.2.12-alpine
  net: ${CUSTOM_NETWORK_NAME}
  expose:
    - "6379"
```

5. Add the following variables to the LDAP container section in docker-compose.yml

```
GITLAB_PLATFORM_USERNAME: ${GITLAB_PLATFORM_USERNAME}
GITLAB_PASSWORD: ${GITLAB_PWD}
```

6. Add the following variables to the Jenkins container section in docker-compose.yml

```
GITLAB_HOST: "gitlab"
GITLAB_USERNAME: ${GITLAB_JENKINS_USERNAME}
GITLAB_PASSWORD: ${PASSWORD_JENKINS}
```

7. Run the following command to deploy Gitlab

```
./adop compose up
```

8. Migrate Gerrit repositories to Gitlab. This step ensures you do not lose the content of your Gerrit repositories when migrating to Gitlab. You can follow this guide as an example of how to do this: **[Import project from repo by URL](https://docs.gitlab.com/ee/user/project/import/repo_by_url.html)**. Note: if you do not move your repositories from Gerrit to Gitlab you will **lose your repository data**. If your Gerrit contains a large number of repositories, we recommend writing a Jenkins job to automate the migration, you can use modify **[adop-cartridge-skeleton](https://github.com/Accenture/adop-cartridge-skeleton/tree/master/src)** and urls.txt to do this.
9. Backup your adop-docker-compose folder and clone the latest version containing gitlab from here: **[https://github.com/Accenture/adop-docker-compose](https://github.com/Accenture/adop-docker-compose)**. This will add the Gitlab config to docker-compose and update the images for Jenkins, Gitlab and Nginx. Use the below commands as an example:

```
mv adop-docker-compose adop-docker-compose-old
git clone https://github.com/Accenture/adop-docker-compose.git
```

10. Copy your platform.secrets.sh to the updated folder

```
cp adop-docker-compose-old/platform.secrets.sh adop-docker-compose/
```

11. Run the below commands to deploy the latest version of ADOP

```
cd adop-docker-compose
./adop compose down
# if deployed in AWS run the next command if not run the appropriate command for your ADOP
export PRIVATE_IP=$(curl http://instance-data/latest/meta-data/local-ipv4)
./adop compose -i {PRIVATE_IP} up --with-stdout
```

Test all the containers as well as images are up.

12. Remove the Gerrit volumes

```
docker rm gerrit-mysql
docker rm gerrit
```

13. After logging into ADOP/C, it will look like the below screen. The dashboard will have Gitlab instead of Gerrit:
<img src="/adop-docker-compose/images/docs/adopc-dashboard.png" alt="ADOP/C Dashboard" />

## Post-deployment Steps

After the above successfully deploying Gitlab on ADOP/C, follow the below steps to ensure Jenkins is configured correctly:

1. Need to add update "ADOP_PLATFORM_MANAGEMENT_VERSION" in Manage Jenkins.
2. Go to Jenkins drop down -> Manage Jenkins -> Configure System -> Global properties to the correct commit id (For e.g. it should be f922a490fbaf2856c4745a5185a3e6e9870f7944).
3. On the DevOps Dashboard, navigate and select Jenkins.
4. Go to Workspace Management → Generate Workspace →  and Configure <img src="/adop-docker-compose/images/docs/jenkins-workspace.png" alt="jenkins workspace" />
5. Find all the reference for "Gerrit" by Ctrl+f and searching for Gerrit.
6. Replace the repository URL to point to github repo - https://github.com/Accenture/adop-platform-management.git
7. And remove all the reference to Gerrit:
Before: <img src="/adop-docker-compose/images/docs/shell-script-gerrit.png" alt="job execute shell with gerrit reference" />
After: <img src="/adop-docker-compose/images/docs/shell-script-github.png" alt="job execute shell with github reference" />
8. Save and Build with parameters after giving a name to the It should run successfully.
9. Navigate to the Workspace created above → Project management → Generate Project → Configure.
10. Again search for Gerrit and remove all mentions of the same. As well as change the **Repository URL** to **Github url**. 
11. Save and build with parameters.
12. Give your project a name and build, it should successfully create a new project space.
13. Navigate to the workspace and select the project created above → Cartridge Management → Load Cartridge → Configure.
14. Again search for Gerrit and remove all mentions of the same. As well as change the **Repository URL** to **Github url**. 
15. Save and Build with Parameters.
16. You will then need to go through all jobs that clone/push to Gerrit and replace the URLs with Gitlab one (which were migrated as part of the migration steps).
