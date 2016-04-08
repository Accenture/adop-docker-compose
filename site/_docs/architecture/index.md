---
layout: docs
chapter: Architecture
title: Component Overview 
permalink: /docs/architecture/
---

ADOP is made up of the following components:

* [Core](/adop-docker-compose/docs/architecture/core/)
    * The Core consists of a selection of DevOps tools provided as Docker images and deployed using Docker Compose
    * The tools are pre-configured to be aware of the other tools within the network where necessary
    * Platform functionality has been built into Jenkins to support cartridges, project namespacing and platform extensions - as described below
* [Project Namespacing](/adop-docker-compose/docs/architecture/project-namespacing/)
    * Functionality is built into the tools to support namespacing based on workspaces and projects
    * This also feeds into the access control model
* [Cartridges](/adop-docker-compose/docs/architecture/cartridges/)
    * Standardised approach of packaging and sharing reusable software delivery assets
    * Defines the Git repositories with sample code, Jenkins jobs and pipelines that define a reference implementation for a particular technology
* [Platform Extensions](/adop-docker-compose/docs/architecture/platform-extensions/)
    * Provides the ability to extend the Core and add new tools or extensions to existing tools
    * If it’s not in the Core and it could be used by multiple cartridges, it is probably a platform extension
* [Command Line Interface](/adop-docker-compose/docs/architecture/cli/)
    * The command line interface provides a way to provision and interact with the platform
    * It is intended for us by both end users and for automation purposes
