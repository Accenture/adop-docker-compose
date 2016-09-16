---
layout: docs
chapter: Operating
title: Platform 
permalink: /docs/operating/platform/
---

By default, once you setup your ADOP stack this job is trigerred automatically, however if there is a need to run it manually, in order to create ADOP Platform follow below steps:

1. Navigate to your Jenkins home page.
1. Click on "Load_Platform" job.
1. Click on "Build with Parameters:
    - GIT_URL: ```https://github.com/Accenture/adop-platform-management.git```
    - GENERATE_EXAMPLE_WORKSPACE: ```Tick if you want an example workspace to be generated together with ADOP Platform```

1. It will take aproximately one minute for the platform to be loaded.


"Load_Platform" job creates two new folders "Platform_Management" and "Workspace_Management", as shown below, folders should be visible in Jenkins:
<img src="/adop-docker-compose/images/docs/platform_after_load_new_folders.png" alt="Image showing new folders which are created by building Load_Platform job." />