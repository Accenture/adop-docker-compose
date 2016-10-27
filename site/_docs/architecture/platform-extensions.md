---
layout: docs
chapter: Architecture
title: Platform Extensions
permalink: /docs/architecture/platform-extensions/
---

Platform extensions provide the ability to extend the Core and add new tools or extensions to existing tools. The general rule of thumb is that if it’s not in the Core and it could be used by multiple cartridges, it is probably a platform extension.

Platform extensions are defined according to the [platform extension specification](https://github.com/Accenture/adop-platform-extension-specification) which can be used as a basis for [platform extension development](/adop-docker-compose/docs/developing/platform-extensions/).

## Platform Extension Collections
Platform extensions can be grouped together into collections so that related platform extensions can be loaded in one go.

## Platform Extension Types

There are currently two methods of loading platform extensions.

### AWS

This type uses the AWS CloudFormation services to load a template that describe the AWS resources to create.

Examples
  * [adop-platform-extension-chef](https://github.com/Accenture/adop-platform-extension-chef)

### Docker

This uses [docker-compose](https://docs.docker.com/compose/) to orchestrate the running of containers.

Examples
  * [adop-platform-extension-clair](https://github.com/kramos/adop-platform-extension-clair)
