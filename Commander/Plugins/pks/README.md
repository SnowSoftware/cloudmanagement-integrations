# PKS Plug-in Workflow Step Package

This package contains a collection of workflow steps for interacting with Pivotal Container Service (PKS) on vSphere.

It was designed specifically for use in the Commander workflow extension scenario *Deploying a Kubernetes Cluster on vSphere through PKS*, which can be found on the [Embotics Support Knowledge Base](https://support.embotics.com/support/home).

## Changelog

- **Version 2.0:** Updated underlying Kubernetes library requiring updates to resource API paths. The Version 2.0 plug-in is supported with Commander release 7.1.0 and higher.
- **Version 1.1:** 
  - Added List PKS Kubernetes Clusters step and Delete PKS Kubernetes Cluster step. 
  - Added extra error handling and logging.
  - The Version 1.1 and 1.0 plug-ins are supported with Commander release 7.0.2 and higher.
- **Version 1.0:** Initial version.

## Plug-in steps in this package

+ Create PKS Kubernetes Cluster
+ Delete PKS Kubernetes Cluster
+ Get PKS Kubeconfig
+ List PKS Kubernetes Clusters

### Create PKS Kubernetes Cluster
**Purpose:** Creates a Kubernetes cluster in a vSphere PKS environment

**Workflows supporting this plug-in step:**

  * Command workflows
  * Completion workflows for a VM
  * Completion workflows for a service
  * Completion workflows for a cloud template
  * Completion workflows for a custom component

**Inputs:**

* Step Name: Input field for the name of the step.
* Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
* Cluster Name: Input field for the name of the cluster. This is the friendly, managed system name in displayed in Commander.
* PKS API Server: Input field for the address of the load balancer for the PKS API and UAA server. This must be an FQDN
* Sys Credentials: Drop-down that sets the system credentials for the PKS API server.
* Plan Name: Input field for the plan name to use to create a PKS k8s cluster.
* Node Count: Input field for the number of worker nodes in the k8s cluster. If this field is blank, the default value from the plan is used.
* Domain Name: Input field for the domain name of the PKS environment. **Note**: The FQDN for the load balancer is the <cluster-name>.<domain-name>.
* Creation Timeout:  Input field for the maximum amount of time (in minutes) for the workflow to create the cluster.

### Delete PKS Kubernetes Cluster

**Purpose:** Deletes a single PKS cluster

**Workflows supporting this plug-in step:**

- Command workflows
- Completion workflows for a change request
- Completion workflows for a VM
- Completion workflows for a service
- Completion workflows for a cloud template
- Completion workflows for a custom component

**Inputs:**

* Step Name: Input field for the name of the step
* Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
* Cluster Name: Input field for the name of the cluster. This is the friendly, managed system name in displayed in Commander.
* PKS API Server: Input field for the address of the load balancer for the PKS API and UAA server. This must be an FQDN.
* Sys Credentials: Drop-down that sets the system credentials for the PKS API server

### Get PKS Kube Config

**Purpose:** Requests credentials (that is, kubeconfig) from PKS to be used to add the cluster to Commander

**Workflows supporting this plug-in step:**

* Command workflows
* Completion workflows for a VM
* Completion workflows for a service
* Completion workflows for a custom component
* Completion workflows for a cloud template

**Inputs:**

* Step Name: Input field for the name of the step
* Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
* Cluster Name: Input field for the name of the cluster. This is the friendly, managed system name in displayed in Commander.
* PKS API Server: Input field for the address of the load balancer for the PKS API and UAA server. This must be an FQDN.
* Sys Credentials: Drop-down that sets the system credentials for the PKS API server

### List PKS Kubernetes Clusters

**Purpose:** View the details and last action taken on one or all PKS clusters

**Workflows supporting this plug-in step:**

- All

**Inputs:**

* Step Name: Input field for the name of the step
* Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
* Cluster Name: (Optional) Input field for the name of the cluster. This is the friendly, managed system name in displayed in Commander. If left blank, all PKS clusters will be returned.
* PKS API Server: Input field for the address of the load balancer for the PKS API and UAA server. This must be an FQDN.
* Sys Credentials: Drop-down that sets the system credentials for the PKS API server

## Installation

See [Adding plug-in workflow steps](https://docs.embotics.com/commander/Using-Plug-In-WF-Steps.htm#Adding) in the Commander documentation to learn how to install this package. 

## Return Codes

### Generic Return Codes
+ **0** - *Step completed successfully*
+ **100** - *Commander returned a general exception*

### Create PKS Kubernetes cluster return codes
+ **1** - *PKS Credentials were not valid*
+ **2** - *Create cluster failed*
+ **4** - *Timeout error* 

### Get PKS Kubeconfig return codes
+ **1** - *PKS Credentials were not valid*
+ **3** - *Invalid kube config returned*

### List PKS Clusters

- **1** - *PKS Credentials were not valid*

### Delete PKS Cluster

- **1** - *PKS Credentials were not valid*
- **5** - *Delete cluster failed*

## Logging
Add the following named loggers to the Log4j configuration file located in `\Embotics\Commander\tomcat\common\classes\log4j2.xml` to update the logging level.
+ **Create PKS Kubernetes cluster**
    + Loggers:
      + `<Logger level="DEBUG" name="wfplugins.pks.createk8scluster"/>`
+ **Get PKS Kubeconfig**
    + Loggers:
        - `<Logger level="DEBUG" name="wfplugins.pks.getkubeconfig"/>`

+ **List PKS Clusters**
    + Loggers:
        - `<Logger level="DEBUG" name="wfplugins.pks.listk8scluster"/>`
+ **Delete PKS Cluster**
    + Loggers:
        - `<Logger level="DEBUG" name="wfplugins.pks.deletek8scluster"/>`

