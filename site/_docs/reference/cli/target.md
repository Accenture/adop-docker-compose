---
layout: docs
chapter: Reference - CLI
title: target
permalink: /docs/reference/cli/target/
---

[Back to CLI Commands](/adop-docker-compose/docs/reference/cli/)

## Command

`./adop target <subcommand>`

Used for setting up environment variables to connect with ADOP stack.

## Subcommands

### set

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Subcommand</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">set [&#60;options>]</td>
		<td>Sets the environment variables to point to ADOP stack.</td>
	</tr>
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">-t [&#60;ENDPOINT>]</td>
		<td>Sets the endpoint URL to connect to ADOP stack, where <b>&#60;ENDPOINT></b> the URL to ADOP stack (required) (hint: https://54.77.198.55/).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-u [&#60;USERNAME>]</td>
		<td>Sets the username required for authentication with ADOP stack, where <b>&#60;USERNAME></b> the username with permissions to access ADOP stack (required).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">-p [&#60;PASSWORD>]</td>
		<td>Sets the password required for authentication with ADOP stack, where <b>&#60;PASSWORD></b> the password with permissions to access ADOP stack (required).</td>
	</tr>
</table>

### unset

Unsets the environment variables pointing to ADOP stack.

### help

Prints out help information.

## Examples [WIP]
