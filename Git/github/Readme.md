# Completion modules to Pull down a Github Repo with a Personal Access token

This completion module contain steps to connect to a GitHub Repo, git clone it locally and then assign the path to the requesting Organisation.
 - Requires git-SCM for Windows installed onto your Commander Server (https://git-scm.com/download/win)
 - Commander 9.3.0 or higher
 - Advanced property "embotics.workflow.script.credentials" must be set to "true"
 - Default Path for your Git Repo to be hosted locally
 - You GitHub Personal Access Token saved into a credential that is named the same as the organization that is requesting it
 - The Path to your GitHub repo to clone

## Changelog

**Version 1.0:** Initial version.

## Completion modules and workflows
+ GitHub pull request - NEW (GitHub_pull_Request_-_NEW_Module.json)
+ GitHub import - NEW (Github_import_-_NEW_Workflow.json)

### Github pull request
**Purpose:** 

The module allow you to clone a private GitHub repo to the commander server then update the organisations custom attribute with the path to the cloned repo. This provides quick access to code to be executed in future workflows quickly and easily based on organisations.

**Workflows supporting this modules:**

  * Custom Component Completion

**Inputs:**
  * BaseURL
  * ByPassCert
  * GitHubDefaultPath
  * githubclonepath
  * GitRepoCustomAttribute
  * Overrideexistingfile
  

**Usage:**

Github Pull Request & Github Import

- Import the Github pull Request - NEW module into the completion modules section of Self-Service
- Import the Github Import - NEW workflow into the completion workflows section of Self-Service
- Add the Github pull Request - NEW module to your completion Workflow (If not automatically done) and ensure you provide at a minimum the BaseURL (Your commander URL), Githubdefaultpath and githubcustomattribute

Note:  We recommend that you have a form attribute or input text field configured on your blueprint and set this value for the githubclonepath input variable field in your workflow. This will allow you to capture the text and pass this into the workflow and module for execution.
