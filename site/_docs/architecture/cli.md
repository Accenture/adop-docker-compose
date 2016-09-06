---
layout: docs
chapter: Architecture
title: Command Line Interface
permalink: /docs/architecture/cli/
---

The command line interface provides a standard way of initialising and interacting with the platform.

It makes use of Docker Machine (if applicable) and Docker Compose where required, and in the case of interacting with the platform provides an abstraction on top of the jobs in Jenkins.

## Getting started - init
For simplicity some people will prefer to start from the [quickstart.sh](/adop-docker-compose/docs/quickstart/) wrapper script.  However if you have:

* Docker locally installed on your machine, or
* Already set up your shell to point to the docker command line tool to a remote docker instance or Swarm, you can get started as follows:
1. Clone the [https://github.com/Accenture/adop-docker-compose](https://github.com/Accenture/adop-docker-compose) repository and change into the adop-docker-compose directory
2. Run
```
 $ ./adop compose init
```
There you have it, an ADOP will be ready for you to use!
