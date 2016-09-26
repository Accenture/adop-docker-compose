---
layout: docs
chapter: Operating
title: Platform Extensions
permalink: /docs/operating/platform-extensions/
---

Platform extensions provide the ability to extend the core [ADOP stack](/docs/operating/platform/) and add new tools or extensions to existing tools. Below, you will learn how to load a default ADOP platform extension.

1. Access Jenkins
1. Go into "Platform_Management" folder and access "Load_Platform_Extension" job
1. Click on "Build with parameters"
1. Enter the following parameters:
	- GIT_URL ```https://github.com/Accenture/adop-platform-extension-specification```
    - GIT_REF ```master``` (By default we would use value 'master', unless you would be developing an extension and specifically require to use a different branch)
    - AWS_CREDENTIALS ```Applicable for AWS type of platform extensions```
        1. For detailed instructions on how to generate AWS credentials, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html">AWS Credentials</a>
        1. Once you have generated AWS credentials, click on "Add" button and fill in required details as shown below:
        <img src="/adop-docker-compose/images/docs/platform_extension_add_cred.png" alt="Image showing what details to fill out when adding credentials for loading platform extension." />
        1. Click "Add".
1. Click "Build".