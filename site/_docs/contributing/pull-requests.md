---
layout: docs
chapter: Contributing
title: Pull Requests
permalink: /docs/contributing/pull-requests/
---

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can. We have [guidelines for submitting pull requests](/adop-docker-compose/docs/contributing/pull-requests/) to our projects.

Before you start to code (especially for the Core), we recommend discussing your plans through a GitHub issue, especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.

When submitting pull requests we have a few guidelines that we'd like people to follow to make it easier to review and accept contributions:

* The heading and description should clearly explain what the pull request is seeking to achieve
* If the pull request has dependencies on other PRs, please specify them and the order in which they should be applied if applicable
* Commits should be tidy and squashed into logical chunks
    * Multiple commits is fine if they are clear and concise - for example a PR containing fixes for multiple defects could have a commit for each
* Where applicable, Travis must be happy for a PR to be accepted
* When contributing to any of the documentation, either the site or .md files, the changes must render correctly in their target viewer
    * For GitHub Pages this means you will need to publish your changes and either provide a link or a screenshot of them functioning

[Maintainers](https://github.com/Accenture/adop-docker-compose/wiki/Project-Roster#project-maintainers) will follow these rules when reviewing and accepting Pull Requests:

* Pull Requests shouldn't be accepted by the person that created them
* Even if a change looks simple, crowd source some testing on Gitter to verify compatibility
* PRs that add or remove something from the platform additionally needs approval from a [roadmap approver](https://github.com/Accenture/adop-docker-compose/wiki/Project-Roster#roadmap-approvers)
