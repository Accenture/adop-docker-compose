---
layout: docs
chapter: Reference - CLI
title: certbot
permalink: /docs/reference/cli/certbot/
---

[Back to CLI Commands](/adop-docker-compose/docs/reference/cli/)

## Command

`./adop certbot <subcommand> [<options>]`

Used for running ADOP Certbot related commands.

*Originally, this script was developed in order to support Docker Registry, but while we developing it, we realized, that it's actually can be more abstract and used for entire stack, so that you can have SSL-enabled secure stack.*

## Subcommands

### gen-export-certs

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Subcommand</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">gen-export-certs [&#60;options>]</td>
		<td>Generates self-signed certificates and export them to the ADOP Proxy (NGINX)</td>
	</tr>
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">&#60;domain-name></td>
		<td>Sets the Domain Name for which self-signed certificates will be issued (required).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">&#60;service-name></td>
		<td>Sets the Service Name, where &#60;SERVICE-NAME> is the reference name for which you want to generate certificates (optional). In case of "registry" service-name specifically, script will also export certificates to the ADOP Docker Registry certs volume.</td>
	</tr>
</table>

### gen-letsencrypt-certs

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Subcommand</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">gen-letsencrypt-certs [&#60;options>]</td>
		<td>Request (generate) SSL certificates issued by Let's Encrypt.</td>
	</tr>
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">&#60;domain-name></td>
		<td>Sets the Domain Name for which certificates by Let's Encrypt will be issued (required).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">&#60;service-name></td>
		<td>Sets the Service Name, where &#60;SERVICE-NAME> is the reference name for which you want to generate certificates (optional).</td>
	</tr>
</table>

### export-letsencrypt-certs

<table style="font-size:12px">
	<tr> <!-- Splitter -->
		<th>Subcommand</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">export-letsencrypt-certs [&#60;options>]</td>
		<td>Export SSL certificates issued by Let's Encrypt to the ADOP Proxy (NGINX) container.</td>
	</tr>
	<tr> <!-- Splitter -->
		<th>Option</th>
		<th></th>
	</tr>
	<tr>
		<td style="white-space: nowrap">&#60;domain-name></td>
		<td>Sets the Domain Name for which, certificates issued by Let's Encrypt before (by gen-letsencrypt-certs), will be exported to the Docker volumes (required).</td>
	</tr>
	<tr>
		<td style="white-space: nowrap">&#60;service-name></td>
		<td>Sets the Service Name, where &#60;SERVICE-NAME> is the reference name for which you want to enable NGINX configuration from sites-available to sites-enabled (optional)</td>
	</tr>
</table>

## Examples

Generate and export self-signed certificates

```
./adop certbot gen-export-certs registry.<adop-ip-address>.nip.io registry
```

Request (generate) issued by Let's Encrypt certificates
 
```
./adop certbot gen-letsencrypt-certs registry.<adop-ip-address>.nip.io registry
./adop certbot gen-letsencrypt-certs <adop-ip-address>.nip.io
```

Export issued by Let's Encrypt certificates to the ADOP Proxy volume and Enable NGINX link configuration from sites-available to sites-enabled

```
./adop certbot export-letsencrypt-certs registry.<adop-ip-address>.nip.io registry
./adop certbot export-letsencrypt-certs <adop-ip-address>.nip.io
```
