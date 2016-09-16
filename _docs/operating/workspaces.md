---
layout: docs
chapter: Operating
title: Workspaces 
permalink: /docs/operating/workspaces/
---

Workspace is a working directory for a collection of projects. In order to create a workspace for your project, follow the steps below.

1. Access Jenkins
1. Go into "Workspace_Management" folder and access "Generate_Workspace" job
1. Click on "Build with parameters"
1. Enter the following parameters:
	- WORKSPACE_NAME ```The name of the workspace to be generated.```
	- ADMIN_USERS ```Users (emails) that will be given admin (full-access) access to this workspace, comma separated.```
	- DEVELOPER_USERS ```Users (emails) that will be given developer (non-admin jobs) access to this workspace, comma separated.```
	- VIEWER_USERS ```Users (emails) that will be given viewer (read-only) access to this workspace, comma separated.```
1. Click "Build".