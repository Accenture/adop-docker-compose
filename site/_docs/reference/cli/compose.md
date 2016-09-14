---
layout: docs
chapter: Reference - CLI
title: compose
permalink: /docs/reference/cli/compose/
---

[Back to CLI Commands](/adop-docker-compose/docs/reference/cli/)

## Command

`./adop compose [<options>] <subcommand>`

Used for running Docker Compose related commands.

## Options

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap"> -m &#60;name> </td>
		<td>Targets a specific Docker Machine, where <b>&#60;name></b> is the name of the Docker Machine to target.</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-f &#60;path></td>
		<td>Specifies an additional override file for Docker Compose, where <b>&#60;path></b> is the path to the override file (can be specified more than once).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-F &#60;path></td>
		<td>Specifies file to use for Docker Compose (in place of default), where <b>&#60;path></b> is the path to the file (can be specified more than once).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-l &#60;driver></td>
		<td>Specifies logging driver, where <b>&#60;driver></b> is the name of the driver.</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-v &#60;driver></td>
		<td>Specifies the volume driver, where <b>&#60;driver></b> is the name of the driver.</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-n &#60;name></td>
		<td>Specifies the custom network to create (if not present) and use, where <b>&#60;name></b> is the name of the network.</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-i &#60;ip></td>
		<td>Specifies the public IP that the proxy will be accessed from (only required when not using Docker Machine), where <b>&#60;ip></b> is the public proxy IP.</td>
	</tr>
</table>

## Subcommands

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Subcommand</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">init</td>
		<td>Initialises ADOP.</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">init &#60;--without-load></td>
		<td>Initialises ADOP without loading the platform.</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">init &#60;--without-image></td>
		<td>Initialises ADOP without pulling the images.</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">up</td>
		<td>docker-compose up for ADOP.</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">gen-certs &#60;path></td>
		<td>Generates client certificates for TLS-enabled Machine and copies the certificates to <b>&#60;path></b> in Jenkins Slave.</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">&#60;command></td>
		<td>Runs ‘docker-compose ’ for ADOP, where &#60;command> is not listed above.</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">help</td>
		<td>Prints help information.</td>
	</tr>
</table>

## Examples [WIP]

`./adop compose -m MyDocker init`