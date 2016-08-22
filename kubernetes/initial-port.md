
## initial port
docker compose files to kubernetes yaml: https://github.com/skippbox/kompose.

```
$ kompose convert -y -f ../docker-compose.yml
[ error messages suppressed ...]
file "proxy-svc.yaml" created
file "jenkins-deployment.yaml" created
file "sonar-mysql-deployment.yaml" created
file "sonar-deployment.yaml" created
file "ldap-phpadmin-deployment.yaml" created
file "nexus-deployment.yaml" created
file "sensu-api-deployment.yaml" created
file "gerrit-mysql-deployment.yaml" created
file "sensu-client-deployment.yaml" created
file "sensu-redis-deployment.yaml" created
file "sensu-server-deployment.yaml" created
file "ldap-deployment.yaml" created
file "ldap-ltb-deployment.yaml" created
file "jenkins-slave-deployment.yaml" created
file "sensu-rabbitmq-deployment.yaml" created
file "selenium-hub-deployment.yaml" created
file "sensu-uchiwa-deployment.yaml" created
file "gerrit-deployment.yaml" created
file "selenium-node-chrome-deployment.yaml" created
file "proxy-deployment.yaml" created
file "selenium-node-firefox-deployment.yaml" created
```

use `helm` (https://github.com/kubernetes/helm) and create some charts.
```
helm create adop
cd adop/charts
helm create ldap
mv ../ldap-*.yaml ldap/templates
```
