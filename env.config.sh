#!/bin/bash

# Proxy

export LDAP_SERVER="ldap:389"
export LDAP_PASSWORD="***REMOVED***"

# LDAP

export LDAP_ADMIN_PASSWORD="***REMOVED***"
export LDAP_LOG_LEVEL=0

# Gerrit MySQL

export MYSQL_ROOT_PASSWORD="***REMOVED***"
export MYSQL_USER="gerrit"
export MYSQL_PASSWORD="***REMOVED***"
export MYSQL_DATABASE="gerrit"

# Gerrit

export DB_PORT="3306"
export DB_NAME="gerrit"
export DB_USER="gerrit"
export DB_PASSWORD="***REMOVED***"
export LDAP_PASSWORD="***REMOVED***"
export USER_NAME="Gerrit Code Review" 
export USER_EMAIL="gerrit@adop"

# Sonar MySQL

export MYSQL_ROOT_PASSWORD="***REMOVED***"
export MYSQL_USER="sonar"
export MYSQL_PASSWORD="***REMOVED***"
export MYSQL_DATABASE="sonar"

# Sonar

export LDAP_BIND_PASSWORD="***REMOVED***"

# Jenkins

export LDAP_MANAGER_PASSWORD="***REMOVED***"
export SONAR_ACCOUNT_LOGIN="jenkins"
export SONAR_ACCOUNT_PASSWORD="***REMOVED***"
export SONAR_DB_LOGIN="sonar"
export SONAR_DB_PASSWORD="***REMOVED***"
export SONAR_PLUGIN_VERSION=""
export SONAR_ADDITIONAL_PROPS=""
export SONAR_RUNNER_VERSION="2.4"
export ANT_VERSION="1.9.4"
export MAVEN_VERSION="3.0.5"
export NODEJS_VERSION="0.12.2"
export NODEJS_GLOBAL_PACKAGES="grunt-cli@~0.1.13 bower@~1.3.12 plato@~1.2.1"
export NODEJS_PACKAGES_REFRESH_HOURS="72"

# Logstash

export LS_HEAP_SIZE=1024m

# Nexus

export LDAP_BIND_PASSWORD="***REMOVED***"