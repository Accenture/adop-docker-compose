# helm charts for kubernetes
this dir contains all charts necessary to run adop on kubernetes, deployed with helm.

# under active development
working:
- ldap
- selenium
- sonar
- nexus
- sensu
- gerrit
- jenkins

broken:
- dashboard link to selenium (https://github.com/Accenture/adop-docker-compose/issues/50)

untested
- actual build in jenkins

## prereq
- os x, linux or windows (untested)
- minikube: https://github.com/kubernetes/minikube/releases
- helm: https://github.com/kubernetes/helm/releases

if you run on windows [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and optionally [babun](http://babun.github.io/)

## run
start minikube and initialize [helm](https://github.com/kubernetes/helm) (a package manager for kubernetes)
```
minikube start --memory=6144 --cpus=4
helm init
```

### full adop

via repo
```
helm repo add adop https://s3-eu-west-1.amazonaws.com/adop-latest
helm update
helm install adop/adop-0.1.0
```
via git clone
```
cd adop-docker-compose/
helm install kubernetes/adop
```
depending on your bandwidth, the download might take a while.
get a coffee and access adop at [192.168.99.100:30080](http://192.168.99.100:30080/) with adop/adop

that's it. see `debugging` below for more infos


### single service
```
helm install kubernetes/adop/charts/ldap
helm install kubernetes/adop/charts/gerrit
```

## todo
- create remaining volumes from etc/volumes/local/default.yml, see adop-nginx for an example
- figure out ELK integration (kubernetes ELK runs in kube-system)
- set user-facing variables just once in values.yaml (password etc)
- limit container cpu resources
- create health-checks
- submit to kubernetes/charts official repo



## debugging
start with more RAM
```
minikube delete
minikube start --memory 8192
```
### kubernetes dashboard
http://192.168.99.100:30000/
### ssh
`minikube ssh`
```
➜  ~ minikube ssh
                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o           __/
             \    \         __/
              \____\_______/
 _                 _   ____     _            _
| |__   ___   ___ | |_|___ \ __| | ___   ___| | _____ _ __
| '_ \ / _ \ / _ \| __| __) / _` |/ _ \ / __| |/ / _ \ '__|
| |_) | (_) | (_) | |_ / __/ (_| | (_) | (__|   <  __/ |
|_.__/ \___/ \___/ \__|_____\__,_|\___/ \___|_|\_\___|_|
Boot2Docker version 1.11.1, build master : 901340f - Fri Jul  1 22:52:19 UTC 2016
Docker version 1.11.1, build 5604cbe
docker@minikubeVM:~$ docker ps
CONTAINER ID        IMAGE                                                        COMMAND                  CREATED             STATUS              PORTS               NAMES
3362140aac10        accenture/adop-nginx:latest                                  "/resources/scripts/e"   15 minutes ago      Up 15 minutes                           k8s_proxy.41a472e1_proxy-2092717670-o2i1y_test_ec75223b-60f7-11e6-8b35-d23414a771f6_d6e7950b
43265f412f8e        gcr.io/google_containers/pause-amd64:3.0
```
`kubectl`
- [kubectl-1.3.5-linux-amd64](https://storage.googleapis.com/kubernetes-release/release/v1.3.5/bin/linux/amd64/kubectl)
- [kubectl-1.3.5-darwin-amd64](https://storage.googleapis.com/kubernetes-release/release/v1.3.5/bin/darwin/amd64/kubectl)
- [kubectl-1.3.5-windows-amd64](https://storage.googleapis.com/kubernetes-release/release/v1.3.5/bin/windows/amd64/kubectl)

`misc`
```
watch kubectl --namespace=adop get pods && kubectl delete ns adop
helm install --namespace=adop kubernetes/adop
kubectl --namespace=adop logs -f ldap-xxx
kubectl --namespace=adop edit deployment nexus
```
## adop modifications
- patched adop-nexus because LDAP_PORT variable conflicts with kubernetes
- patched adop-nginx to start even though kibana is not available
