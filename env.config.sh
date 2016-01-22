#!/bin/bash

# Proxy

export LDAP_SERVER="ldap:389"
export LDAP_PASSWORD="Sw4syJSWQRx2AK6KE3vbhpmL"

# LDAP

export LDAP_ADMIN_PASSWORD="Sw4syJSWQRx2AK6KE3vbhpmL"
export LDAP_LOG_LEVEL=0

# Gerrit MySQL

export MYSQL_ROOT_PASSWORD="Password01"
export MYSQL_USER="gerrit"
export MYSQL_PASSWORD="gerrit"
export MYSQL_DATABASE="gerrit"

# Gerrit

export DB_PORT="3306"
export DB_NAME="gerrit"
export DB_USER="gerrit"
export DB_PASSWORD="gerrit"
export LDAP_PASSWORD="Sw4syJSWQRx2AK6KE3vbhpmL"
export USER_NAME="Gerrit Code Review" 
export USER_EMAIL="gerrit@adop"

# Sonar MySQL

export MYSQL_ROOT_PASSWORD="sonar"
export MYSQL_USER="sonar"
export MYSQL_PASSWORD="sonar"
export MYSQL_DATABASE="sonar"

# Sonar

export LDAP_BIND_PASSWORD="Sw4syJSWQRx2AK6KE3vbhpmL"

# Jenkins

export LDAP_MANAGER_PASSWORD="Sw4syJSWQRx2AK6KE3vbhpmL"
export SONAR_ACCOUNT_LOGIN="jenkins"
export SONAR_ACCOUNT_PASSWORD="jenkins"
export SONAR_DB_LOGIN="sonar"
export SONAR_DB_PASSWORD="sonar"
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

export LDAP_BIND_PASSWORD="Sw4syJSWQRx2AK6KE3vbhpmL"