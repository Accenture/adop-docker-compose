---
layout: docs
chapter: Architecture
title: Project Namespacing 
permalink: /docs/architecture/project-namespacing/
---

Project namespacing is implemented in several of the tools across the platform where it makes sense to subdivide to prevent collisions and also to support multi-tenancy.

Namespacing involves the following two concepts:

* Workspaces
    * Contain one or more projects
* Projects
    * Contain one or more loaded cartridges

The following tools support namespacing:

* [Jenkins](#jenkins)
* [Gerrit](#gerrit)

## Jenkins
Namespacing in Jenkins is achieved using:

* [CloudBees Folders plugin](https://wiki.jenkins-ci.org/display/JENKINS/CloudBees+Folders+Plugin)
    * To allow folders to be created that namespace the jobs
* [Role Strategy plugin](https://wiki.jenkins-ci.org/display/JENKINS/Role+Strategy+Plugin)
    * To restrict which groups have access to the different namespaces

## Gerrit
Namespacing in Gerrit is achieved by:

* Creating repositories within directories that are aligned with the namespacing in [Jenkins](#jenkins)
* Creating a project-specific permissions repository that restricts access to all repositories within that project
