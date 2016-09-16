---
layout: docs
chapter: Operating
title: Projects 
permalink: /docs/operating/projects/
---

Since you have now created your [workspace](/adop-docker-compose/docs/operating/workspaces), you will be able to generate a project inside of that workspace.

1. Access Jenkins
1. Go into the workspace folder which you have [created](/adop-docker-compose/docs/operating/workspaces) and access "Generate_Project" job
1. Click on "Build with parameters"
1. Enter the following parameters:
	- PROJECT_NAME ```The name of the project to be generated.```
	- ADMIN_USERS ```Users (emails) that will be given admin (full-access) access to this project, comma separated.```
	- DEVELOPER_USERS ```Users (emails) that will be given developer (non-admin jobs) access to this project, comma separated.```
	- VIEWER_USERS ```Users (emails) that will be given viewer (read-only) access to this project, comma separated.```
1. Click "Build".