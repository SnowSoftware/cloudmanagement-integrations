# Kubernetes Plug-in Workflow Step Package

This package contains a collection of Commander plug-in workflow steps for interacting with Kubernetes resources. It was designed specifically for use in several Kubernetes scenarios, such as running a Kubernetes best practice report, which can be found on the [Embotics Support Knowledge Base](https://support.embotics.com/support/home).

## Changelog

- **Version 2.0:** Updated underlying Kubernetes library requiring updates to resource API paths. The Version 2.0 plug-in is supported with Commander release 7.1.0 and higher.
- **Version 1.0:** Initial version. The Version 1.0 plug-in is supported with Commander release 7.0.2 and higher.

## Plug-in steps in this package

+ Kubernetes Add to Inventory
+ Kubernetes Best Practices
+ Kubernetes Deploy Resource
+ Kubernetes Remove Resource

### Kubernetes Add to Inventory

**Details:**

- Adds a Kubernetes cluster as a Commander managed system
- Supported in completion and command workflows

**Workflows supporting this plug-in step:**

* Command workflows
* Completion workflows for a VM
* Completion workflows for a service
* Completion workflows for a custom component
* Completion workflows for a cloud template

**Inputs:**

- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Cluster Name: Input field for the name of the cluster. This is the friendly managed system name in Commander.
- Cluster Config: Input field for the cluster configuration in kubeconfig format
  - This field can contain a variable that resolves to the kubeconfig
  - If this field contains a file path that is accessible to the Commander service account, the file is read, and its contents are used as the kubeconfig

### Kubernetes Best Practices 

**Details:**

- Executes a series of checks against a Kubernetes cluster and generates an XML report which can be written to disk as-is or transformed to HTML and emailed to recipients
- Supported only in command workflows
- The content of this report is available after step execution in the step output, accessible with `#{steps['step name'].output}`
- The content of this report uses the same format as Ant + Junit, making it suitable to upload to tools such as Jenkins or to translate in to HTML using an XSLT stylesheet
- To learn more, see the scenario *Running a Kubernetes Best Practices Report*, available from the [Embotics Support Knowledge Base](https://support.embotics.com/support/home).

**Workflows supporting this plug-in step:**

 * Command workflows
 * Completion workflows for a change request
 * Completion workflows for a service
 * Completion workflows for a custom component

**Inputs:**

- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Rules File: (Optional) Input field for the path to a rule configuration file. If this input is omitted, the default set of rules is used. (`default-best-practices-rules.yaml` can be downloaded from the same location as this plug-in step package.)

### Kubernetes Deploy Resource

**Details:**

- Deploys a set of resources based on the provided YAML descriptor in a manner similar to `kubectl --namespace="yamlns" apply -f "yamlfile.yaml"`

**Workflows supporting this plug-in step:**

* Command workflows
* Completion workflows for a change request
* Completion workflows for a service
* Completion workflows for a custom component 

**Inputs:**
- Step Name: Input field for the name of the step. 
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Namespace: Input field to specify the namespace to which the resource will be deployed
  - If a namespace is specified in the Namespace field, that namespace is used, and any manifest-specified namespace is ignored
  - If the Namespace field is blank, and the manifest is provided, then the latter is used
  - If both the Namespace and the manifest-specified namespace are blank, then the default namespace is used
- K8s YAML Manifest: Input field for YAML manifests that describe the resource to deploy
  - Must be a valid Kubernetes Resource format. See [Understanding Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/) for more information.
  - Should contain one or more manifests (separated by ---)
  - If a namespace is specified in the Namespace field, any namespace specified in a provided manifest is ignored
  - If the Namespace field is blank and no namespace is specified in a provided manifest, the default namespace is used
- Deploy Type options:
  - Create or Update: Creates a new resource if the resource does not exist, and updates if the resource does exist
  - Create only: Creates a new resource (fails if resource already exists)
  - Update only: Updates an existing resource (fails if resource does not exist)
- Variable inputs are permitted in the Namespace and Manifest field
  - The step can use an Upload File element in a form through the following variable: `#{target.settings.fileUpload['Test'].file[1].content}`
  - Note: `fileUpload['Test']` refers to the element name from the form and `file[1]` returns the first file from the element (there may be multiple) 

### Kubernetes Remove Resource

**Details:**

- Supported only in Command workflows
- Removes a set of resources based on provided yaml descriptor in a manner similar to `kubectl --namespace="yamlns" delete -f "yamlfile.yaml"`

**Workflows supporting this plug-in step:**

* Command workflows
* Completion workflows for a change request
* Completion workflows for a service
* Completion workflows for a custom component

**Inputs:**

- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Namespace: Input field specifying the namespace to remove the resource from
  - If blank, the manifest must specify a namespace; if not blank, the manifest-specified namespace is ignored
- K8s YAML manifest: Text field for the manifests to be removed
  - Must be a valid Kubernetes Resource format (https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/)
  - Should contain one or more manifests (separated by ---)
  - If a namespace is specified in the Namespace field, any namespace specified in the manifest is ignored
  - If no namespace is specified in the Namespace field, and no namespace is specified in the manifest, the default namespace is used

## Installation

See [Adding plug-in workflow steps](https://docs.embotics.com/commander/Using-Plug-In-WF-Steps.htm#Adding) in the Commander documentation to learn how to install this package. 

## Return codes

### Generic return codes

*Examples:*

+ **0** - *Step completed successfully*
+ **100** - *Return code explanation*

### Deploy/Remove step return codes
+ **1** - *Invalid namespace value provided*
+ **2** - *YAML validation error*
+ **3** - *Provided namespace does not exist; it must be created first*
+ **4** - *Provided manifest namespace does not exist; it must be created first*
+ **5** - *YAML provided could not be converted*
+ **6** - *Invalid Kubernetes manifest provided*
+ **7** - *Kubernetes returned a JSON exception (message output is from Kubernetes API server)*
+ **8** - *Kubernetes returned an exception ((message output is from Kubernetes API server)*
+ **9** - *Resource already exists on the cluster and update is not enabled*
+ **10** - *Resource does not exist on the cluster and create is not enabled*
+ **11** - *Resource was not deleted as expected - see cluster for details*
+ **12** - *Invalid resource action type provided*
+ **13** - *Kubernetes resource validation error*
  
### Best Practices return codes
+ **50** - *Unable to read the rules file*
+ **51** - *Invalid or empty rules file*
  
### Add to Inventory return codes
+ **71** - *Cluster name is required*
+ **72** - *Invalid Kubernetes config file provided*
+ **73** - *Kubernetes config file required*

## Logging
To change the logging level, add the following named loggers to the Log4j configuration file located at: 

`<vcommander-install>\tomcat\common\classes\log4j2.xml` 

*Examples*:

+ **General Utilities**
    + Loggers:
      + `<Logger level="DEBUG" name="wfplugins.k8s.yamlutils"/>`

+ **Deploy Resource** 
    + Loggers:
      + `<Logger level="DEBUG" name="wfplugins.k8s.resource"/>`
      + `<Logger level="DEBUG" name="wfplugins.k8s.resource.deploy"/>`

## Notes

- Selecting the "Update" deploy type for a namespace manifest will fail with the following error: *"Message: The namespace of the object (default) does not match the namespace on the request"*. If updating a namespace is required, use the "Create or update" deploy type.
- Updates to a Kubernetes cluster may not appear immediately after the step's completion because some time is allowed for the polling cycle to reset. To ensure the latest data appears in Commander, manually synchronize the managed system's inventory.
- The Deploy/Remove Resource steps do not provide support for all Kubernetes resources. For example, the ClusterRoleBinding resource should be pre-deployed on the Kubernetes cluster to be used in an resource.
- The Deploy/Remove Resource steps do not support all API versions.  Some support is included for the "apps" endpoint for Deployments where the API version is automatically changed to the supported "extensions/v1beta1" endpoint.