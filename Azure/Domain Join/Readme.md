# Completion modules to Domain Join Windows Servers in your Azure Subscription

These completion modules contain steps to Join a Windows Server to a Domain.
 - Requires PS module AZ on the Commander server. (https://learn.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-9.4.0) 
 - Commander 9.3.0 or higher
 - Advanced property "embotics.workflow.script.credentials" must be set to "true"
 - Azure Run Command Plugin for Commander (https://github.com/Embotics/Plug-in-Workflow-Steps/tree/master/azureruncmd)

## Changelog

**Version 1.0:** Initial version.

## Completion modules
+ Join the VM to your Domain (Azure - Domain Join.json)
+ De-Join your VM from the Domain (Azure - Domain Dejoin.json)

### Azure Windows VM Domain Join
**Purpose:** 

These set of modules allow you to Join an Azure hosted VM to your Domain.  This will allow you to join the machine in the OU of your choosing, if no OU is provided then it will join the server to the Domain in the default location (Generally OU=Computers,DC=<Domain>,DC=<Domain>)

**Workflows supporting this modules:**

  * After VM Deployment
  * After a Change Request is fulfilled

**Inputs:**
  * Azure - Domain Join
    *  Domain
	*  OU
     

**Usage:**

Azure - Domain Join

- Import the Azure - Domain Join module into the completion modules section of Self-Service
- Add the Azure - Domain Join module to your completion Workflow and Ensure you provide at a minimum a Domain
- Set the Condition of the workflow as follows (as a minimum):  #{target.cloudAccount.type} -eq "ms_arm"

Azure - Domain Dejoin

- Import the Azure - Domain Dejoin module into the completion modules section of Self-Service
- Add the Azure - Domain Dejoin module to your completion Workflow for Decomissions
- Set the Condition of the workflow as follows (as a minimum):  #{target.cloudAccount.type} -eq "ms_arm"

Note:  We recommend that you have a form attribute configured for Domain Join and have values of Yes and No. This will allow you to decide if a Machine needs to be domain joined or not and will also allow you to target decommissions against only those servers that are joined to the domain.
