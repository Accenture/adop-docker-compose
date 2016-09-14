---
layout: docs
chapter: Operating
title: Command Line Interface 
permalink: /docs/operating/cli/
---

* Spin up [ADOP](/adop-docker-compose/docs/quickstart/)
* [./adop compose](#adop-compose)
* [./adop extension](#adop-extension)
* [./adop project](#adop-project)
* [./adop target](#adop-target)
* [./adop workspace](#adop-workspace)


# adop compose
Used for running Docker Compose related commands.

Usage: `./adop compose [<options>] <subcommand>`

Options:
-----
- `-m <name>` The name of the Docker Machine to target
- `-f <path>` Additional override file for Docker Compose, can be specified more than once
- `-F <path>` File to use for Docker Compose (in place of default), can be specified more than once
- `-l <driver>` The logging driver to use
- `-v <driver>` The volume driver to use
- `-n <name>` The custom network to create (if not present) and use
- `-i <ip>` The public IP that the proxy will be accessed from (only required when not using Docker Machine)
 
Subcommands:
-----
- `init` Initialises ADOP
- `init <--without-load>` Initialises ADOP without loading the platform
- `init <--without-image>` Initialises ADOP(Accenture DevOps Platform) without pulling images
- `up` docker-compose up for ADOP
- `gen-certs <path>` Generate client certificates for TLS-enabled Machine and copy to `<path>` in Jenkins Slave
- `<command>` Runs 'docker-compose <command>' for ADOP, where `<command>` is not listed above
- `help` Prints help information

# adop extension
Used for running ADOP extension related commands.

Subcommands/Options:
-----
- `load [<options>]` Load an extension into adop stack.
	- usage: `adop extension load [<options>]`
		- Options:
			- `-u <GIT_URL>` Git repository url to load extension. (Required)
			- `-r <GIT_REF>` Git reference name. (Optional) (Deafult : master)
			- `-c <AWS_CREDENTIALS>` AWS Credentials. (Required)
			- HINT: Run `adop extension load -u https://github.com/Accenture/adop-platform-extension-specification -c aws` to load an extension.
			  
- `load_collections [<options>]` Load the collection of extensions into adop stack.
	- usage: `adop extension load_collection [<options>]`
		- Options:
			- `-u <EXTENSION_COLLECTION_URL>` URL to a JSON file defining the extension collection. (Required)
			- `-c <AWS_CREDENTIALS>` AWS Credentials. (Required)

- `add_credentials [<options>]` Add the credentials to jenkins in adop stack.
	- usage: `adop extension add_credentials [<options>]`
		- Options:
			- `-u <USERNAME>` Username for jenkins credentials.
			- `-p <PASSWORD>` Password for jenkins credentials.
			- `-i <CREDENTIAL_ID>` ID with which the credentials will be saved to jenkins. (Required) (HINT : `-i basic-auth`) (Must be unique)
			- `-h` Prints this help.
			- HINT: Run 'adop extension add_credentials -u <AWS_ACCESS_KEY_ID> -p <AWS_SECRET_ACCESS_KEY> -i <aws-credentials>' to add a aws credential to jenkins.

# adop project
Used for creating a project space within a workspace in ADOP jenkins instance.

Usage: `./adop project [<options>] <subcommand>`

Options
-----
- `-p <PROJECT_NAME>` The name of the project space. (Required)
- `-w <WORKSPACE_NAME>` The name of the existing workspace. (Required)

Subcommands:
-----
- `create [<options>]` Create a new project in an existing workspace in jenkins.
	- usage: `./adop project -p <PROJECT_NAME> -w <WORKSPACE_NAME> create [<options>]`
		- Options:
			- `-a <ADMIN_USERS>` Comma separated list of users with administrator access to the created project space. (Optional) (Default : blank)
			- `-d <DEVELOPER_USERS>` Comma separated list of users with developer access to the created project space. (Optional) (Default : blank)
			- `-v <VIEWER_USERS>` Comma seperated list of users with read only access to the created project space. (Optional) (Default : blank)
- `load [<options>]` Load the cartridge into the specified workspace/project.
	- usage: `./adop project -p <PROJECT_NAME> -w <WORKSPACE_NAME> load [<options>]`
		- Options:
			- `-u <CARTRIDGE_CLONE_URL>` URL of the cartridge to be loaded. (Required) (Note : It has be a valid url, from the list of the available choices.)
			- `-f <CARTRIDGE_FOLDER>` Name of the folder where the cartridge will be loaded. (Optional) (By default loads the cartridge into workspace/project)
			- `-n <FOLDER_DISPLAY_NAME>` Folder name displayed in Jenkins UI. (Optional)  (Default : `<CARTRIDGE_FOLDER>`)
			- `-d <FOLDER_DESCRIPTION>` Description of the folder where the cartridge will be loaded. (Optional) (Default : blank)
			- `-r <ENABLE_CODE_REVIEW>` This is to control whether to enable code review or not for the repositories loaded by cartridge. (Optional) (Default: false)
			- HINT: Run `adop project -p <PROJECT_NAME> -w <WORKSPACE_NAME> load -u ssh://jenkins@gerrit:29418/cartridges/adop-cartridge-java.git` to load java reference catridge in adop jenkins instance under existing workspace/project.
- `load_collection [<options>]` Load the collection of cartridges into the specified workspace/project.
	- usage: `./adop project -p <PROJECT_NAME> -w <WORKSPACE_NAME> load_collection [<options>]`
		- Options:
			- `-c <CARTRIDGE_COLLECTION_URL>` URL to a JSON file defining your cartridge collection. (Required)
- HINT: Run `adop project -p <PROJECT_NAME> -w <WORKSPACE_NAME> create` to create a project in an existing workpsace in adop jenkins instance.

# adop target
For setting up environment variables to connect with adop stack.

Usage: `./adop target <subcommand>`

Subcommands:
-----
- `set [<options>]` Sets the environment variables to point to adop stack.
	- usage: `./adop target set [<options>]`
		- Options:
			- `-t <endpoint>` The endpoint url to connect to adop stack. (Required) (HINT : http://54.77.198.55)
			- `-u <username>` The username required for authentication with adop stack. (Required)
			- `-p <password>` The password required for authentication with adop stack. (Required)
- `unset` Unsets the environment variables pointing to adop stack.
- `help` Prints this help information

# adop workspace
For setting up workspaces to store projects.

Usage: `./adop workspace [<options>] <subcommand>`

Options:
-----
- `-w <WORKSPACE_NAME>` The name of the workspace. (Required)

Subcommands:
-----
- `create [<options>]` Create a new workspace in jenkins.
	- usage: `./adop workspace -w <WORKSPACE_NAME> create [<options>]`
		- Options:
			- `-a <ADMIN_USERS>` Comma separated list of users with administrator access to the created workspace. (Optional) (Default : blank)
			- `-d <DEVELOPER_USERS>` Comma separated list of users with developer access to the created workspace. (Optional) (Default : blank)
			- `-v <VIEWER_USERS>` Comma seperated list of users with read only access to the created workspace. (Optional) (Default : blank)