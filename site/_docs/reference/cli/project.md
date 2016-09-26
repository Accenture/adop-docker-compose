---
layout: docs
chapter: Reference - CLI
title: project
permalink: /docs/reference/cli/project/
---

[Back to CLI Commands](/adop-docker-compose/docs/reference/cli/)

## Command

`./adop project [<options>] <subcommand>`

Used for creating a project space within a workspace in ADOP Jenkins instance.

## Options

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap"> -p &#60;PROJECT_NAME> </td>
		<td>Sets the name of the project space, where <b>&#60;PROJECT_NAME></b> is the name of the project space which you will be using (required).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-w &#60;WORKSPACE_NAME></td>
		<td>Specifies the name of the existing workspace, where <b>&#60;WORKSPACE_NAME></b> is the name of the existing workspace in Jenkins instance (required).</td>
	</tr>
</table>

## Subcommands

### create

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Subcommand</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">create [&#60;options>]</td>
		<td>Creates a new project in an existing workspace in Jenkins.</td>
	</tr>
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">-a [&#60;ADMIN_USERS>]</td>
		<td>Sets users with admin permissions on the project space, where <b>&#60;ADMIN_USERS></b> is a comma separated list of users (optional) (default: blank).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-d [&#60;DEVELOPER_USERS>]</td>
		<td>Sets users with developer permissions on the project space, where <b>&#60;DEVELOPER_USERS></b> is a comma separated list of users (optional) (default: blank).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-v [&#60;VIEWER_USERS>]</td>
		<td>Sets users with viewer (read-only) permissions on the project space, where <b>&#60;VIEWER_USERS></b> is a comma separated list of users (optional) (default: blank).</td>
	</tr>
</table>

### load

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Subcommand</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">load [&#60;options>]</td>
		<td>Loads a catridge into the specified workspace/project.</td>
	</tr>
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">-u [&#60;CARTRIDGE_CLONE_URL>]</td>
		<td>Sets the URL of the cartridge to be loaded, where <b>&#60;CARTRIDGE_CLONE_URL></b> is the URL of the cartridge (required) (Note: has to be a valid URL from the list of cartridges available in Jenkins).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-f [&#60;CARTRIDGE_FOLDER>]</td>
		<td>Sets the name of the folder where the cartridge will be loaded, where <b>&#60;CARTRIDGE_FOLDER></b> is the name of the folder (optional) (by default: loads cartridge into workspace/project).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-n [&#60;FOLDER_DISPLAY_NAME>]</td>
		<td>Sets the folder name which will be visible in Jenkins UI, where <b>&#60;FOLDER_DISPLAY_NAME></b> is the display name (optional) (default: blank).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-d [&#60;FOLDER_DESCRIPTION>]</td>
		<td>Sets the description of the folder into which cartridge will be loaded, where <b>&#60;FOLDER_DESCRIPTION></b> is the description of the folder (optional) (default: blank).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-r [&#60;ENABLE_CODE_REVIEW>]</td>
		<td>Controls whether to enable code review or not for the repositories loaded by the cartridge, where <b>&#60;ENABLE_CODE_REVIEW></b> is true or false depending on the requirement (optional) (default: false).</td>
	</tr>
</table>

### load_collection

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Subcommand</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">load_collection [&#60;options>]</td>
		<td>Loads a catridge into the specified workspace/project.</td>
	</tr>
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">-c [&#60;CARTRIDGE_COLLECTION_URL>]</td>
		<td>Sets the URL to JSON file defining your cartridge collection, where <b>&#60;CARTRIDGE_COLLECTION_URL></b> is the URL to the Jenkins file (required).</td>
	</tr>
</table>

## Examples [WIP]

* `./adop project -p <PROJECT_NAME> -w <WORKSPACE_NAME> create` - creates a project in an existing workspace in ADOP Jenkins instance.
* `./adop project -p <PROJECT_NAME> -w <WORKSPACE_NAME> load -u ssh://jenkins@gerrit:29418/cartridges/adop-cartridge-java.git` - loads Java reference catridge in ADOP Jenkins instance under existing workspace/project.