---
layout: docs
chapter: Reference - CLI
title: extension
permalink: /docs/reference/cli/extension/
---

[Back to CLI Commands](/adop-docker-compose/docs/reference/cli/)

## Command

`./adop extension <subcommand> [<options>]`

Used for running ADOP extension related commands.

## Subcommands

### load

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Subcommand</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">load [&#60;options>]</td>
		<td>Loads an extension into ADOP stack.</td>
	</tr>
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">-u [&#60;GIT_URL>]</td>
		<td>Sets the Git repository to load the extension from, where <b>&#60;GIT_URL></b> is the URL to the Git repository (required).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-r [&#60;GIT_REF>]</td>
		<td>Sets the Git reference name, where <b>&#60;GIT_REF></b> is the reference name (optional) (<b>default: master</b>).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-c [&#60;AWS_CREDENTIALS>]</td>
		<td>Sets the Amazong Web Services Credentials, where <b>&#60;AWS_CREDENTIALS></b> is the <b>CREDENTIAL_ID</b> which you can setup using <a href="#add-credentials"><b>add_credentials</b></a> command (required).</td>
	</tr>
</table>

### load_collections

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Subcommand</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">load_collections [&#60;options>]</td>
		<td>Loads an the collection of extensions into ADOP stack.</td>
	</tr>
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">-u [&#60;EXTENSION_COLLECTION_URL>]</td>
		<td>Sets the URL to a JSON file defining the extension collection, where <b>&#60;EXTENSION_COLLECTION_URL></b> is the URL to the JSON file(required).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-c [&#60;AWS_CREDENTIALS>]</td>
		<td>Sets the Amazong Web Services Credentials, where <b>&#60;AWS_CREDENTIALS></b> is the <b>CREDENTIAL_ID</b> which you can setup using <a href="#add-credentials"><b>add_credentials</b></a> command (required).</td>
	</tr>
</table>

### add_credentials

<a name="add-credentials" style="font-size:0px">add_credentials anchor</a> <!-- anchor -->
<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Subcommand</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">add_credentials [&#60;options>]</td>
		<td>Adds the credentials to Jenkins in ADOP stack.</td>
	</tr>
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">-u [&#60;USERNAME>]</td>
		<td>Sets the username for Jenkins credentials, where <b>&#60;USERNAME></b> is any generic username (i.e. "aws-user") (required).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-p [&#60;PASSWORD>]</td>
		<td>Sets the password for Jenkins credentials, where <b>&#60;PASSWORD></b> is any generic password (for added security use alphanumeric combination as well as special characters)(required).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-p [&#60;CREDENTIAL_ID>]</td>
		<td>Sets the ID with which the credentials will be saved to Jenkins, where <b>&#60;CREDENTIAL_ID></b> is any generic name (i.e. <i>-i basic-auth</i>)(required) (must be unique).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">help</td>
		<td>Prints help information.</td>
	</tr>
</table>

## Examples [WIP]

`./adop extension load -u https://github.com/Accenture/adop-platform-extension-specification -c aws`