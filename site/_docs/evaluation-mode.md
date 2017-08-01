---
layout: docs
title: Evaluation Mode 
permalink: /docs/evaluation-mode/
---

Evaluation mode is intended to be the quickest path to running the DevOps Platform, and is ideal for the following use cases:

* Trialing the DevOps Platform and the tools within it
* Proof of concepts/demos
* Local development environment for the DevOps Platform

It is not suitable for, nor intended to be used, in production as there are numerous operational items that need to be taken care of by the deployer:

* Security
    * Quickstart uses Docker Machine to launch a VM that is public facing and leaves the Docker Engine port exposed
* Backups
    * Data is stored directly on the host that is created which means that when it is terminated the data will be lost
* Patching
    * Once the DevOps Platform has been deployed manual intervention will be required to apply patches

