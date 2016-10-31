---
layout: docs
chapter: Operating
title: Cartridges 
permalink: /docs/operating/cartridges/
---

Once you [generate a project](/adop-docker-compose/docs/operating/projects), you will be able to load [cartridges](/adop-docker-compose/docs/architecture/cartridges/).

Prerequisite

Please follow below instruction if you are loading cartridge from a private repository to enable SSH key permission from your Jenkins to the private repository:

1.	Navigate to the following Jenkins URL (http://<public-ip>/jenkins/userContent)
2.	Select the id_rsa.pub file and copy the contents.
3.	Navigate to your private repository and add the access key



Load Cartridge

1. Access Jenkins
1. Go into the [workspace](/adop-docker-compose/docs/operating/workspaces) folder.
1. Go into the [project](/adop-docker-compose/docs/operating/projects) folder and access "Load_Cartridge" job.
1. Go into "Cartridge Management" folder.
1. Access "Load_Cartridge" job.
	a.	If your loading cartridge from a private repository (ensure the Jenkins public keys are added to private repository access keys as stated above), or even if loading it from a different branch, then add your projects repository URL by following below steps:
		I.	From "Load_Cartridge" job, click "Configure" to get to the configuration of this job
		II.	Add the desired "<CARTRIDGE_URL>" to your cartridge URL in parameter “Choices”, under “Choice Parameter” section.
		III.	Click "Save" to save your changes and “Apply” to close the job configuration

1. Click on "Build with parameters"
1. Enter the following parameters:
	- `CARTRIDGE_CLONE_URL` - Select cartridge URL to load from the dropdown list.
	- `CARTRIDGE_FOLDER` - The folder name within the project namespace where your cartridge will be loaded into.
	- `FOLDER_DISPLAY_NAME` - Display name of the folder where the cartridge is loaded.
	- `FOLDER_DESCRIPTION` - Description of the folder where the cartridge is loaded.
	- `ENABLE_CODE_REVIEW` - Enables Gerrit Code Reviewing for the selected cartridge.
	- `OVERWRITE_REPOS` - If ticked, existing code repositories will be overwritten. For first time cartridge runs, this property is redudant.
1. Click "Build".



Load Multiple Cartridges


You can load multiple cartridges at once by running “Load_Cartridge_Collection”. In order to load multiple cartridge, please ensure to enable SSH from your Jenkins to all repositories of cartridge in your JSON file. 
Follow below steps to load multiple cartridges:

1. Access Jenkins
1. Go into the [workspace](/adop-docker-compose/docs/operating/workspaces) folder.
1. Go into the [project](/adop-docker-compose/docs/operating/projects) folder and access "Load_Cartridge" job.
1. Go into "Cartridge Management" folder.
1. Access "Load_Cartridge_Collection" job.
1. Click on "Build with parameters"
1. Enter the following parameters:
	- `COLLECTION_URL` - URL to a JSON file defining your cartridge collection.
1. Click "Build".

