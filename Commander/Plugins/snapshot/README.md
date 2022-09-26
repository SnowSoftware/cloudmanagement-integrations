# Snapshot Plug-in Workflow Step Package

This package contains a collection of Commander plug-in workflow steps for managing VM snapshots on VMware, AWS & Azure

It can be used in the Commander workflow extension scenario *Patching Windows VMs*, which can be found on the [Embotics Support Knowledge Base](https://support.embotics.com/support/home). It can also be used outside of Commander scenarios.

## Changelog

**Version 2.0:** Added support for AWS and Azure.

**Version 1.0:** Initial version.

## Plug-in steps in this package
+ Create Snapshot
+ Delete Snapshot
+ Revert Snapshot

## Create Snapshot

**Purpose:** Creates a new snapshot.

**Workflows supporting this plug-in step:**

* Command workflows
* Completion workflows for a VM
* Completion workflows for a  shared VM
* Change request approval workflows
* Completion workflows for a change request 

**Inputs:** 

- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Snapshot Name: Input field for the name of the snapshot to create
- Description: (Optional) Input field for Snapshot description
- Capture Memory option (VMware Only)
- Quiesce Filesystem option (VMware Only)

See the vCenter Client documentation for more information on the Capture Memory and Quiesce Filesystem options.

## Delete Snapshot

**Purpose:** Deletes the latest snapshot with a given name

**Workflows supporting this plug-in step:**

* Command workflows
* Completion workflows for a VM
* Completion workflows for a  shared VM
* Change request approval workflows
* Completion workflows for a change request 

**Inputs:**

- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Snapshot Name: Input field for name of the snapshot to delete

## Revert Snapshot

**Purpose:**  Reverts to the latest snapshot with a given name (VMware Only)

**Workflows supporting this plug-in step:**

* Command workflows
* Completion workflows for a VM
* Completion workflows for a shared VM
* Change request approval workflows
* Completion workflows for a change request 

**Inputs:**
- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Input field for the name of the snapshot to revert to

## Installation

Plug-in workflow steps are supported with Commander release 7.0.2 and higher. 

See [Adding plug-in workflow steps](https://docs.embotics.com/commander/Using-Plug-In-WF-Steps.htm#Adding) in the Commander documentation to learn how to install this package. 

## Logging
To change the logging level, add the following named loggers to the Log4j configuration file located at: 

`<vcommander-install>\tomcat\common\classes\log4j2.xml` 

**General Utilities**

- Loggers:
  - `<Logger level="DEBUG" name="wfplugins.snapshot"/>`