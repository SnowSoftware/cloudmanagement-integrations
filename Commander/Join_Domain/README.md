# Commander - Join Domain (WinRm)

 Module that Joins a VM/Instance to a specified Domain through WinRM
 
## Requirements:
* Commander 8.10.X or Higher 
* A domain Credential in the credential library
* A VM Template Credential in the credential library
* Advanced property "embotics.workflow.script.credentials" must be set to "true"
* Advanced property “embotics.rest.credentials.retrivesensitive” must be set to "true"
* Import the required Module

## Installation and Setup
* Run the server config.ps1 on the commander server 
* Run the Template_client_config.ps1 on the template or image that's going to be deployed by commander.
* Create three "Guest OS" credentials in the commander Credential library. One for Template credentials, one for Joining the domain and one to call the commander API(superuser).  
* Import the Module "Join Domain - WinRM.json" and configure it's Input variables with Domain name and the credential object names. 
* Under steps select the "Execute Join Domain Command" step and set the dropdown to the commander API credential created earlier. 
* Run a test deployment with the module being called in the completion workflow. 

Note: Errors will be written to the comments as well as Commander logs. 
____

*Currently being migrated from [Embotics Git](https://github.com/Embotics)*

### [Commander Documentation](https://docs.snowsoftware.com/commander/index.htm)

### [Commander Knowledge Base](https://community.snowsoftware.com/s/topic/0TO1r000000E5srGAC/commander?tabset-056aa=2)