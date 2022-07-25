# Completion module to enable change requests to check Azure NSG ports

These completion modules contain steps to check ports against an NSG within Azure through change request.
 - Requires PS module AZ on the Commander server.
 - Commander 8.9.0 or higher
 - Advanced property "embotics.workflow.script.credentials" must be set to "true"

## Completion modules
*  Network Security Group Port Check (Network Security Group Port Check (XaaS).json)

## Azure - Check NSG Port Group
 * To check an NSG to confirm if a port exists as part of a rule
 * Supported as a Change Request
 * Port Number supported as an input as part fo the port check

## Setup Steps
1. Import the Network Security Group Port Check workflow into the completion workflow section of Self-Service
3. Create a change request within Self-Service attaching this Workflow as the Completion Workflow
4. Set the Condition of the workflow as follows:  #{target.context.type} -eq "Microsoft.Network/networkSecurityGroups"
5. Create an Input Text Field in the Form named : Port Number

________________

*Currently being migrated from [Embotics Git](https://github.com/Embotics)*

### [Commander Documentation](https://docs.snowsoftware.com/commander/index.htm)

### [Commander Knowledge Base](https://community.snowsoftware.com/s/topic/0TO1r000000E5srGAC/commander?tabset-056aa=2)
