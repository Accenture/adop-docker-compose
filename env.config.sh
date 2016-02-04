#!/bin/bash

# Globals

export LDAP_PWD="***REMOVED***"

# LDAP

export LDAP_DOMAIN="ldap.example.com"
export LDAP_FULL_DOMAIN="dc=ldap,dc=example,dc=com"

# Gerrit MySQL

export GERRIT_MYSQL_USER="gerrit"
export GERRIT_MYSQL_PASSWORD="***REMOVED***"
export GERRIT_MYSQL_DATABASE="gerrit"

# Gerrit

export GERRIT_USER_NAME="Gerrit Code Review" 
export GERRIT_USER_EMAIL="gerrit@adop"

# Sonar MySQL

export SONAR_MYSQL_USER="sonar"
export SONAR_MYSQL_PASSWORD="***REMOVED***"
export SONAR_MYSQL_DATABASE="sonar"

# Jenkins

export SONAR_ACCOUNT_LOGIN="jenkins"
export SONAR_ACCOUNT_PASSWORD="***REMOVED***"
export SONAR_DB_LOGIN=${SONAR_MYSQL_USER}
export SONAR_DB_PASSWORD=${SONAR_MYSQL_PASSWORD}

# Jenkins Certificate Path
####
# "//" to cater for both Windows and Unix path
####
export DOCKER_CLIENT_CERT_PATH="//root/.docker/"

