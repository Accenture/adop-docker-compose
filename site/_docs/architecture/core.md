---
layout: docs
chapter: Architecture
title: Core 
permalink: /docs/architecture/core/
---

The Core is made up of the following sub-components:

* [Docker Images](#docker-images)
    * There are a number of custom Docker images that have been created for ADOP to add in specific configuration and utilities
    * They can be found in the [Accenture repository in Docker Hub](https://hub.docker.com/u/accenture/dashboard/)
* [Docker Compose](#docker-compose)
    * The images and required environment variables are defined within our [docker-compose.yml](https://github.com/Accenture/adop-docker-compose/blob/master/docker-compose.yml)
* [Platform Management](#platform-management)
    * Everything around project namespacing, cartridges, platform extensions, and general platform tasks are covered under [Platform Management](https://github.com/Accenture/adop-platform-management) and utilised by Jenkins

## Docker Images
There are a number of custom Docker images that have been created for ADOP to add in specific configuration and utilities to initialise the platform. Where possible all images are based on official images by the tool/component provider and come from trusted sources.

## Docker Compose
Docker Compose is utilised to define "the product" and capture all of the containers with their configuration necessary to run ADOP.

## Platform Management
This component is responsible for the implementation of the platform features, which is mostly done via Jenkins jobs and a selection of utility scripts. It is loaded into the platform via a "Load_Platform" job that is baked into the ADOP Jenkins image which is responsible for loading in the rest of the [Platform Management](https://github.com/Accenture/adop-platform-management) repository and running the jobs that setup the platform.
