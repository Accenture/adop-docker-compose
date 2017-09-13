---
layout: docs
title: Prerequisites
permalink: /docs/prerequisites/
---

To run ADOP in evaluation mode you will need:

* General
    * Outbound internet connectivity
* A Bash-compatible shell
    * If you aren't on OSX or Linux then Git Bash will work
    * Docker Toolbox can install Git Bash for you
* Docker & Docker Compose
    * Can be installed separately or via Docker Toolbox
    * Docker Engine 1.10.x
    * Docker Compose 1.9.0
* Docker Machine
    * Only required for evaluation mode
    * Docker Machine 0.9.0

To run ADOP outside of evaluation mode (i.e. using the CLI directly) you will need:

* All of the above, except Docker Machine
* A VM with 16GB of RAM
