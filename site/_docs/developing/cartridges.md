---
layout: docs
chapter: Developing
title: Cartridges 
permalink: /docs/developing/cartridges/
---

The process for developing a cartridge is:

* [Spin up ADOP](/adop-docker-compose/docs/quickstart/)
* Read the [development guidelines](#development-guidelines)
* Read about the [cartridge architecture](/adop-docker-compose/docs/architecture/cartridges/)
* Take a look at the [cartridge cookbook](/adop-cartridges-cookbook/)
* Utilise the [Cartridge Development cartridge](#using-the-cartridge-development-cartridge)
* [Develop the cartridge content](#developing-cartridge-content)
* [Test the cartridge against the platform](#testing-the-cartridge)
* [Publish the cartridge](#publishing-cartridges)

## Development Guidelines
When developing a cartridge, it is advisable to follow the guidelines below in order to develop stable, secure and standardized cartridges.

### Jenkins Pipeline
When developing a cartridge, it is recommended that Job DSL be used in favor of XML to write your Jenkins jobs. If your cartridge only uses Job DSL a cartridge can be loaded multiple times without having to create a new project. However, if your cartridge loads XML then the jobs will need to be removed in order to reload the cartridge.

There are a number of resources available for developing Job DSL that can be found on the [Job DSL plugin wiki](https://github.com/jenkinsci/job-dsl-plugin/wiki).

High-level guidelines for writing Jenkins jobs in Job DSL:

* Build Wrappers
    * Ensure that you are using the preBuildCleanup() wrapper in your Job DSL to make sure that your Jenkins workspace is cleared before every build.
    * Do not make any credentials visible anywhere in your job i.e. do not echo passwords in your shell script or store credentials as plain-text build parameters. Ensure you are always using the maskPasswords() and injectPasswords() wrappers in your Job DSL.
        * Credentials can also be added manually to the Jenkins credential store and then referenced in your job.
    * It is highly recommended that the sshAgent() wrapper be used with the Jenkins credentials specified in order to allow Jenkins to clone all local git repositories from Gerrit over SSH.
* Git SCM
    * Ensure that all your git clones are over SSH (not HTTPS) using the Jenkins SCM plugin (it is advisable not to do any git clones in your shell script unless specifically required to do so).
    * When cloning from external git repositories, ensure that you only clone from trusted git repositories.
    * When cloning a git repository, it better to clone using a reference rather than a branch specifier. The way to do this is by specifying the variable $GERRIT_NEWREV in the "Branch Specifier" variable. This is useful in the case of jobs that need to be rebuilt, and it is preferred that the code from that specific build be cloned as opposed to the latest code on a specific branch.
* Miscellaneous
    * It is preferable to set your jobs to build on the Jenkins slave as opposed to the Jenkins master.
    * It is advisable to set up Log Rotation in order to discard old builds and artifacts so as to not occupy unnecessary space on the server. This can be implemented via the logRotator() option in Job DSL.

The table below lists some useful Job DSL functions to use when writing your Jenkins jobs:

| Job DSL Method | Function |
|-----|-----|
|label()|Allows you to specify a slave label where the job will be built|
|preBuildCleanup()|Clears Jenkins job workspace before every build|
|injectPasswords()|Allows you to inject global Jenkins credentials as well as your custom-defined credentials into the job|
|maskPasswords()|Hides the injected passwords so that they are not visible in plan text|
|sshAgent()|Specify SSH credentials to be used when cloning from repositories over SSH|
|scm()|Define a repository and a branch specifier to clone|
|triggers()|Specify an event (e.g. Gerrit trigger) to start a job|
|steps()|Build steps to execute e.g. shell(), SonarQube()|
|publishers()|List the post-build actions to execute after build steps have completed|

### Source code
The src folder in a cartridge will contain a single urls.txt file which will contain a list of clone urls for source code git repositories to be loaded in during cartridge creation.

* It is advisable to use this file to load any repositories containing any source code as opposed to manually creating the repositories in Gerrit and then configuring manually configuring your Jenkins jobs to clone from the created repository.
* The repositories must be cloned over HTTPS from the specified repository browsers (Github, BitBucket, etc.) and they must be publicly accessible. If this is not the case, the cartridge loader will fail to load the repositories. If the urls provided are SSH clone urls, then the Jenkins SSH key must be added to the relevant repository browser.

## Using the Cartridge Development cartridge
This development cartridge allows you to load a cartridge template, creates a repository for it in Gerrit, load your cartridge from Gerrit, validate it and then publish it to an external Git repository host.

To use it:

* Create a project to load the cartridge
    * Ideally create a [new project](/adop-docker-compose/docs/operating/projects/) within a [new workspace](/adop-docker-compose/docs/operating/workspaces/)
    * Select "adop-cartridge-cartridge-dev" when loading the cartridge
* Run the CreateNewCartridge job in Jenkins which will create a repository in Gerrit
* Clone the Gerrit repository and add the cartridge content
* When the cartridge is ready, you may validate it using the ValidateCartridgeRepo job in Jenkins
* To test the functionality of the cartridge, you may use LoadDevCartridge to load an instance of your cartridge into your ADOP Core
* When you are satisfied with the content and functionality of your cartridge, you may use PublishCartridgeRepo to push your cartridge to an external Git repository


## Developing Cartridge Content

### Source Code
A cartridge will typically contain a reference application, and optional supporting repositories. In an ideal world all content relating to a component should be versioned in the same place, however this may not always be possible (e.g. if the reference application is owned by someone else) or practical.

As a bare minimum there will need to be some code, usually a reference application, that will be consumed by the pipeline and probably deployed to some kind of environment. For example, you might have a Java application that your pipeline builds and is later deployed to Tomcat.

On top of the actual source code for your reference application you will also need to provide artefacts relating to your pipelines stages - things like unit tests, functional tests, performance tests. Whether or not you need all of these parts will depend on the quality stages that you identify in your pipeline.

### Jenkins Pipeline
The Jenkins pipeline itself will need to be developed, ideally using Job DSL, to cover the stages that you want your component to go through. You will need to identify which jobs you would like to implement and then determine the necessary Job DSL methods required to define your pipeline.

A basic pipeline should as a minimum have steps, where appropriate, for:

* Build/compile
* Unit test
* Static code analysis
* Deploy

More advanced pipelines may also include:

* Automated functional tests -for example using Selenium
* BDD-style automated functional tests
* Performance tests - for example using JMeter or Gatling
* Security tests

Cartridges can also include jobs for creating and destroying environments, or these stages can be included as part of the main pipeline.

## Testing the Cartridge
Once a cartridge has been developed it is necessary to test it against the platform in the same way that consuming users would.

To do this:

1. Push cartridge to a Git repository
1. Add the cartridge URL so it can be loaded 
    1. Via platform-management
    1. Via [modifying Load_Cartridge](#adding-cartridges)
        * Once a project has been created there will be a "Cartridge_Management/Load_Cartridge" job
        * This can be modified to add the cartridge Git repository URL to the parameter list (by default the cartridge development cartridge is included as an option)
1. Create Workspace
1. Create Project
    * See 2.2 if 2.1 was not followed earlier
1. Load Cartridge
    * If your cartridge only uses Job DSL then this can be repeated multiple times without creating a new project
    * If your cartridge loads XML then the jobs will need to be removed to repeat this step
1. Verify the cartridge has loaded as expected
1. Verify that the Jenkins jobs etc. function correctly
1. [Make any necessary fixes/updates & push to your Git repository](#using-the-cartridge-development-cartridge)
1. Rinse repeat 4-9

#### Adding cartridges

Once you have [developed a cartridge](/adop-docker-compose/docs/developing/cartridges/), you can then add your cartridges' URL to "Load_Cartridge".

1. Access "Load_Cartridge" job under "Cartridge Management" folder of your [project](/adop-docker-compose/docs/operating/projects).
1. Click "Configure".
1. Add the [path](#finding-cartridge-url) to your cartridge URL in parameter "Choices", under "Choice Parameter" section.
1. Click "Save".

Your very own cartridge should now be visible in the `CARTRIDGE_CLONE_URL` list of choices.

#### Finding cartridge URL

Easiest way to find a path to your custom cartridge:

1. Access Gerrit via ADOP platform.
1. Click on "Projects", navigate to "List".
1. Find your cartridge path (i.e. ExampleWorkspace/CartridgesProject/DevCart/my-new-cartridge), copy it - you will need it in the next step.
1. Adjust the path: ssh://jenkins@gerrit:29418/ `<YOUR_PATH>` .git

Now you have a full path to your cartridge which, if you wish, you can add it to the `CARTRIDGE_CLONE_URL` list of "Load_Platform" job.

## Publishing Cartridges
Coming soon.
