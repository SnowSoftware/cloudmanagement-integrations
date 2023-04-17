# Commander Sample - Enable creation of a New Azure deployment destinations via Service Portal

To create a new deployment destination to allow recently on-boarded customers to provision workloads effectively. This can be extended easily to have a dynamic list of appropriate resource groups based on selection.
Please refer to https://docs.snowsoftware.com/commander/admin-portal/adding-dynamic-lists-to-forms.htm or contact your Snow representative to learn more.

## Requirements:
These completion modules contain steps to create a deployment destination through service catalog request.
 - Commander 8.8.0 or higher
 - Advanced property "embotics.workflow.credentials.commander" must be set to a "superuser" account to access the Commander API.
 - Advanced property "embotics.workflow.credentials.retrievesensitive" must be set to a "true".
 - Commander - Create a Deployment Destination (Module).json)
 - Azure Cloud account must have an existing Resouce-Group, Subnet and Datastore. 


**Workflows supporting this modules:**

  * Self-Service Completion Request (Commander - Create Deployment Destination (Workflow).json)

**Inputs:**
  * Base URL - Enter your Commander Server URL
  * ByPass Cert -  Chose 'yes' as your response if you are have not configured Commander with a valid certificate.
  * Cloud Account Name - Chose the name of the Cloud account you have added to Commander & want to create the destination to.
  * Commander User - Chose the username of the account you want to utilize this deployment destination. For first time users, please use a default account (i.e. User, Manager, Superuser).
  * Deployment Destination - Chose a unique name for your deployment destination.
  * Organization Name - Chose the organization name or use the #{request.requester.organization.name} variable.
 
## Installation and Setup
Snow Commander - Deployment Destination

- Import the module 'Create_Deployment_Destination_Module.json' into the completion module section of Self-Service
- Import the workflow 'Create_Deployment_Destination_Workflow.json' into the completion workflow section of Self-Service
- Create a Service Catalog request within Self-Service attaching this Workflow as the Completion Workflow
- Create several Input Text Fields based on the inputs noted above.
- Navigate to the recently imported workflow that you added in step 2 - map the workflows appropriately to the input fields, example below: #{target.settings.inputField['Cloud Account Name']}

Note: Errors will be written to the comments as well as Commander logs. 
____

*Currently being migrated from [Embotics Git](https://github.com/Embotics)*

### [Commander Documentation](https://docs.snowsoftware.com/commander/index.htm)

### [Commander Knowledge Base](https://community.snowsoftware.com/s/topic/0TO1r000000E5srGAC/commander?tabset-056aa=2)

