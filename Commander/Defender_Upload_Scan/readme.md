# File Upload Scan Approval Workflow Module

Approval Workflow modules that scan uploaded files in Service and Change Requests for threats using Windows Defender on the Commander host. Files uploaded using the "File Upload" form element in Service and Change requests will be scanned. A result is written to the Workflow Comments for each file uploaded and if any files produce a positive threat identification then the workflow will end with an error.

Uploaded files which have a positive threat identification are not actioned by this workflow as Windows Defender will quarantine, delete or ignore the files as per your Windows Defender settings.

Requirements: 
* Commander 9.0 or higher
* Microsoft Powershell 5.1 or higher
* Windows Defender

Module Inputs
1. File Names Input
* For Service Requests, this field must be populated with the variable replacement string: #{request.services[1].components[1].settings.uploadedFile['Upload Files']}
* For Change Request, this field must be populated with the variable replacement string: #{target.settings.uploadedFile['Uploaded Files']}
* For Service Requests, modify the replacement string to target the correct service[x] and components[x] that contain the file upload field you want to process.
* For both Service and Change Requests, modify the 'Uploaded Files' string to match the name of the File Upload field in your Form.

Module Installation and Setup:
1. Import the Workflow Modules.
2. Make note of the name of the File Upload form element in the Component Form for your Service or the Change Request Form for your Change Request.
3. Add the Workflow Module step to your Approval workflow as the first step. 
4. Modify the replacement string for your request type (see Module Inputs section above).



