---
layout: docs
chapter: Tools
title: Docker Registry
permalink: /docs/tools/docker-registry/
---

* [About Docker Registry](#about-docker-registry)
  * [Insecure Registry](#insecure-registry)
* [Configuration](#configuration)
  * [Self-Signed Certificate](#self-signed-certificate)
    * [Make Self-Signed certificate trusted](#make-self-signed-certificate-trusted)
  * [Let's Encrypt](#lets-encrypt)
* [Example of usage](#example-of-usage)

## About Docker Registry
With the Docker Registry integrated into ADOP, you can build and store your own Docker images privately inside the stack.
You can read more about Docker Registry at [https://docs.docker.com/registry/introduction/](https://docs.docker.com/registry/introduction/)

### Insecure Registry
Docker Registry is designed to use SSL by default and what most importantly, certificate which's issued by a known CA.
You can read more about [Insecure Registry](https://docs.docker.com/registry/insecure/).

It's important to understand, as if you're using QuickStart.sh, **by default this script will deploy [Insecure Registry](https://docs.docker.com/registry/insecure/)** and this way of usage have downsides i.e. requires trusted certificate on each workstation including your own laptop.
But we also have [Let's Encrypt](#lets-encrypt) scripts which would help you to generate real certificates, issued by Let's Encrypt, but we can not implement this way of usage by default (automatically), as Let's Encrypt have strict limits and because of limits, unfortunately we can't guarantee working Docker Registry. You can read more about - [Let's Encrypt Rate Limits](https://letsencrypt.org/docs/rate-limits/).

## Configuration
We've added generation of self-signed certificate for Docker Registry by default in QuickStart.sh script via [Certbot CLI](/adop-docker-compose/docs/reference/cli/certbot/),
which means, whenever you would initialize ADOP via QuickStart.sh, out-of-the-box you will have **Insecure Docker Registry**.

Example of usage (actual lines from QuickStart.sh): 

```
# quickstart.sh

./adop compose -m "${MACHINE_NAME}" ${CLI_COMPOSE_OPTS} init

if [ ${MACHINE_TYPE} == "aws" ]; then
    ./adop certbot gen-export-certs "registry.$(docker-machine ip ${MACHINE_NAME}).nip.io" registry
fi
```

This "./adop certbot gen-export-certs" one command, will:

* Generate Self-Signed certificates
* Copy certificates to the ADOP Docker Registry volume
* Copy certificates to the ADOP Proxy volume
* Copy certificates to the trusted location on a host machine - /etc/docker/certs.d/
* Enable ADOP Proxy, NGINX configuration for ADOP Docker Registry
* Restart ADOP Docker Registry
* Reload ADOP Proxy, NGINX configuration

By the end of all these steps, we'll have successfully deployed Insecure Docker Registry on "registry.<<adop-ip-address>>.nip.io" domain name with [authentication via NGINX](https://docs.docker.com/registry/recipes/nginx/) and LDAP.

It's important to understand, that by default, you would able to operate with Insecure Docker Registry **ONLY INSIDE THE STACK**, for example from ADOP Jenkins or even host-machine (where you'd deployed ADOP), as by Certbot it's already made self-signed certificates trusted.

If you will try to authenticate or pull some Docker image from Insecure Docker Registry, most probably you will get the following:

```
Error response from daemon: Get https://registry.<adop-ip-address>.nip.io/v1/users/: x509: certificate signed by unknown authority
```

It means, that you have to [Make Self-Signed certificate trusted](#make-self-signed-certificate-trusted) on any workstation, from which you're trying to executing those commands, even your own laptop. But, you could also avoid this by using [Let's Encrypt](#lets-encrypt).

### Self-Signed Certificate
Docker Engine support several ways how you can use/trust Insecure Docker Registry.

1. Built-in process via /etc/docker/certs.d/${DOMAIN_NAME}, please, read about this method at [https://docs.docker.com/engine/security/certificates/#/understanding-the-configuration](https://docs.docker.com/engine/security/certificates/#/understanding-the-configuration) 
2. Trust certificate on the OS level - [Make Self-Signed certificate trusted](#make-self-signed-certificate-trusted)
3. Additional options via DOCKER_OPTS such as "---insecure-registry" [https://docs.docker.com/registry/insecure/#/deploying-a-plain-http-registry](https://docs.docker.com/registry/insecure/#/deploying-a-plain-http-registry) - marked as **VERY insecure solution**

#### Make Self-Signed certificate trusted
For each platform the process might be different, please check documentation per platform:

* [Docker for Windows](https://github.com/docker/docker/issues/21189)
* [Docker for Linux](https://docs.docker.com/engine/security/certificates/#/understanding-the-configuration)
* [Docker for Mac](https://docs.docker.com/docker-for-mac/faqs/#how-do-i-add-custom-ca-certificates)

### Let's Encrypt
This way of usage is more preferable, as Let's Encrypt issuing real/valid SSL certificates by known CA **absolutely for free**.

Let's play the scenario, when you want to deploy ADOP via ADOP CLI i.e. without QuickStart.sh, but with Let's Encrypt for Docker Registry, to avoid the situation where you'll have to trust self-signed certificates.

Previously, most probably, you had only one step to initialize ADOP:
```
./adop compose init
```

But now, we would need to add few more steps, one before initialization and one after:

```
./adop certbot gen-letsencrypt-certs registry.<adop-ip-address>.nip.io registry
./adop compose init
./adop certbot export-letsencrypt-certs registry.<adop-ip-address>.nip.io registry
```

The reason why we've to add more steps, is because Let's Encrypt have builtin domain validation process, please read more about this at [https://letsencrypt.org/how-it-works/#domain-validation](https://letsencrypt.org/how-it-works/#domain-validation). All the process of copying certificates etc. will remains the same, as it was described above. What's most important here is that in this way, you'll have "production-ready" Docker Registry, not evaluation-mode as it was with Insecure Docker Registry.

## Example of usage

Authentication:

```
docker login -u <adop-username> -p <adop-password> registry.<adop-ip-address>.nip.io
```

Docker image Pull or Push:

```
docker push registry.<adop-ip-address>.nip.io/imagename:0.0.1
docker pull registry.<adop-ip-address>.nip.io/imagename:0.0.1
```
