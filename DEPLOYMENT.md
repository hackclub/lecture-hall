# Deployment

This document contains an overview of how Lecture Hall is deployed.

---

Lecture Hall is deployed using Heroku through CircleCI every time the tests on `master` pass.

Lecture Hall depends on submodules and Heroku only supports submodules when deploying with git. CircleCI's built-in Heroku integration is through Heroku's API, so we can't use the built-in integration for the deployment.

Instead, we have a Heroku account under the email ci@hackclub.com that CircleCI uses to make the deploys using git -- ci@hackclub.com is set up to allow CircleCI's SSH key.

The development and deployment process is as follows:

1. A developer works on a new feature and submits a pull request from their feature branch to `master`
2. When the pull request is merged, CircleCI begins running tests on `master`
3. If the tests pass, CircleCI adds Heroku as a git remote to the repository in the test environment and issues a push
4. Heroku runs their deployment process and the working build is then made publicly available
