---
layout: docs
chapter: Reference - CLI
title: workspace
permalink: /docs/reference/cli/workspace/
---

[Back to CLI Commands](/adop-docker-compose/docs/reference/cli/)

## Command

`./adop workspace [<options>] <subcommand>`

Used for setting up workspaces to store projects.

## Options

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap"> -w &#60;WORKSPACE_NAME> </td>
		<td>Sets the name for the workspace, where <b>&#60;WORKSPACE_NAME></b> is the name of the workspace that you are creating (required).</td>
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
		<td>Creates a new workspace in Jenkins.</td>
	</tr>
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">-a [&#60;ADMIN_USERS>]</td>
		<td>Sets users with admin permissions on the workspace, where <b>&#60;ADMIN_USERS></b> is a comma separated list of users (optional) (default: blank).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-d [&#60;DEVELOPER_USERS>]</td>
		<td>Sets users with developer permissions on the workspace, where <b>&#60;DEVELOPER_USERS></b> is a comma separated list of users (optional) (default: blank).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-v [&#60;VIEWER_USERS>]</td>
		<td>Sets users with viewer (read-only) permissions on the workspace, where <b>&#60;VIEWER_USERS></b> is a comma separated list of users (optional) (default: blank).</td>
	</tr>
</table>

## Examples [WIP]

`./adop workspace -w <WORKSPACE_NAME> create [<options>]` - creates a new workspace in Jenkins.