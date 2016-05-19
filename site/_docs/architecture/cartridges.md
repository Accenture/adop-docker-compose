---
layout: docs
chapter: Architecture
title: Cartridges 
permalink: /docs/architecture/cartridges/
---

A cartridge is a standardised approach of packaging and sharing reusable software delivery assets. They will typically defines the Git repositories with sample code, Jenkins jobs and pipelines that define a reference implementation for a particular technology.

Cartridges can be loaded into the platform dynamically at any time and multiple cartridges can be loaded concurrently. They are designed for modularity and reuse and as a means for people to contribute to the platform.

Cartridges are defined according to the [cartridge specification](https://github.com/Accenture/adop-cartridge-specification) which is implemented by the [cartridge skeleton](https://github.com/Accenture/adop-cartridge-skeleton) which can be used as a basis for [cartridge development](/adop-docker-compose/docs/developing/cartridges/).

## Cartridge Collections
Cartridges can be grouped together into collections so that related cartridges can be loaded in one go.
