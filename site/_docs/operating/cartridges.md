---
layout: docs
chapter: Operating
title: Cartridges 
permalink: /docs/operating/cartridges/
---

Once you [generate a project](/adop-docker-compose/docs/operating/projects), you will be able to load [cartridges](/adop-docker-compose/docs/architecture/cartridges/).

1. Access Jenkins
1. Go into the [workspace](/adop-docker-compose/docs/operating/workspaces) folder.
1. Go into the [project](/adop-docker-compose/docs/operating/projects) folder and access "Load_Cartridge" job.
1. Go into "Cartridge Management" folder.
1. Access "Load_Cartridge" job.
1. Click on "Build with parameters"
1. Enter the following parameters:
	- `CARTRIDGE_CLONE_URL` - Select cartridge URL to load from the dropdown list.
	- `CARTRIDGE_FOLDER` - The folder name within the project namespace where your cartridge will be loaded into.
	- `FOLDER_DISPLAY_NAME` - Display name of the folder where the cartridge is loaded.
	- `FOLDER_DESCRIPTION` - Description of the folder where the cartridge is loaded.
	- `ENABLE_CODE_REVIEW` - Enables Gerrit Code Reviewing for the selected cartridge.
	- `OVERWRITE_REPOS` - If ticked, existing code repositories will be overwritten. For first time cartridge runs, this property is redudant.
1. Click "Build".