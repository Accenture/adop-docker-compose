---
layout: docs
chapter: Operating
title: Platform Extensions
permalink: /docs/operating/platform-extensions/
---

Platform extensions provide the ability to extend the core [ADOP stack](/docs/operating/platform/) and add new tools or extensions to existing tools. Below, you will learn how to load a default ADOP platform extension.

1. Access Jenkins
2. Go into "Platform_Management" folder and access "Load_Platform_Extension" job
3. Click on "Build with parameters"
4. Enter the following parameters:
    - GIT_URL ```https://github.com/Accenture/adop-platform-extension-specification```
    - GIT_REF ```master``` (By default we would use value 'master', unless you would be developing an extension and specifically require to use a different branch)
    - CREDENTIALS ```Applicable for AWS and Docker type of platform extensions```
				a. AWS Extensions Type
					1. For detailed instructions on how to generate AWS credentials, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html">AWS Credentials</a>
					2. Once you have generated AWS credentials, click on "Add" button and fill in required details as shown below:
        	   <img src="/adop-docker-compose/images/docs/platform_extension_add_cred.png" alt="Image showing what details to fill out when adding credentials for loading platform extension." />
					3. Click "Add".
				b. Docker Extensions Type ``` Credentials are only required for authenticating against private Docker image repositories ```
					1. Once you have generated [docker hub](https://hub.docker.com/) credentials, click on "Add" button and fill in required details.
					2. Click "Add".
5. Click "Build".
