# Veeam Backup and Recovery 11 - Integration

Modules that allow a user to add a vm to a backup job as part of deployment or as an adhoc "Backup Now"

### Requirements
 - Requires Veeam Backup and Recovery Console on the Commander server.
 - Veeam Backup and Recovery 11 or higher.
 - Commander 8.9.0 or higher
 - Advanced property "embotics.workflow.script.credentials" must be set to "true"

### Dynamic List for form based Selection (Optional)
 * Allows users to select Backup Jobs from a List pulled directly from Veeam at the time of the request
 * Copy the contents of Dynamic_List_Backup_Selection.ps1 into a Dynamic list Form Configuration
 * Select your Veeam credential in the credentials list
 * Set the Executable to powershell.exe then run a test to verify it's operation

### Command Module for quick 'add to backup' Action in portal with no Approval
 * Allows users to Add VM to backup Job witout approval
 * Import the Workflow 'Add_to_Specific_Backup_Job-Command_Workflow.json'
 * Edit the newly Imported Workflow, Select your Veeam credential in the credentials list. 
 * Add the IP address or FQDN of your Veeam Server and Specify the Backup Job Name. 
 * edit the workflow name if exposing it in the portal with the jobname. 
 
### Completion Module "Add to Backup"
 * Import the Completion Module 'Add_to_Veeam_Backup_Job-Completion_Module.json'
 * Edit the newly Imported Module, modify the execute script step and Select your Veeam credential in the credentials list. 
 * Configure the Input Variables the IP address or FQDN of your Veeam Server, Port and Specify the Backup Job Name. 
 Note: You can use the input from the dynamic list to allow the user to select from the current Job list in Veeam
 
### Command workflow for quick 'Backup Now' Action in portal with no Approval
 * Allows users to run a quick Backup action to backup Job witout approval
 * Import the Workflow 'Run_Quick_Backup-Command_Workflow.json'
 * Edit the newly Imported Workflow, Select your Veeam credential in the credentials list. 
 * Add the IP address or FQDN of your Veeam Server. 
 
________________

*Currently being migrated from [Embotics Git](https://github.com/Embotics)*

### [Commander Documentation](https://docs.snowsoftware.com/commander/index.htm)

### [Commander Knowledge Base](https://community.snowsoftware.com/s/topic/0TO1r000000E5srGAC/commander?tabset-056aa=2)
