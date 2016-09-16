---
layout: docs
chapter: Developing
title: Platform Extensions [WIP] 
permalink: /docs/developing/platform-extensions/
---

The process for developing a platform extension is:

* [Spin up ADOP](/adop-docker-compose/docs/quickstart/)
* Read the [development guidelines](#development-guidelines)
* Read about the [platform extension architecture](/adop-docker-compose/docs/architecture/platform-extensions/)
* [Develop the platform extension content](#developing-platform-extension-content)
* [Test the platform extension against the platform](#testing-the-platform-extension)
* [Publish the platform extension](#publishing-platform-extensions)

## Development Guidelines
When developing a platform extension, it is advisable to follow the guidelines below in order to develop stable, secure and standardized platform extensions.

### Services
ADOP platform extension [specification](https://github.com/Accenture/adop-platform-extension-specification) provides capabilities to add aditional services to the platform. 
For example, with clean ADOP platform extension [specification](https://github.com/Accenture/adop-platform-extension-specification) you get two services:

 - aws ```Allows to define a cloudformation template to provision in aws```
 - docker ```Allows to define a docker compose file to provision service on an existing docker engine```
 
### Service Extensions
Existing services in the platform can be extended in order to add more customization. ADOP platform extension [specification](https://github.com/Accenture/adop-platform-extension-specification)
comes with following existing service definitions:

 - jenkins ```Extends the jenkins service to add more configuration and plugins```
 - sonarqube ```Extends sonarqube service to add more plugins, profiles and quality gates```
 - proxy ```Extends proxy service to update release note```
 - sensu ```Extends sensu service to add more checks```

## Developing Platform Extension Content

### Services
Some stuff.

### Service Extensions
Some stuff.

## Testing the Platform Extension
Some stuff.

## Publishing Platform Extensions
Coming soon.
