# AWS Workflow Step Plugins

This package contains a collection of plug-in workflow steps for Amazon Web Services

## Changelog

**Version 1.0:** Initial version. 

## Plug-in steps in this package
+ Create EBS Snapshot
+ Delete EBS Snapshot

### Create EBS Snapshot

This plugin will create an EBS snapshot for the first volume attached to an EC2 instance

**Inputs:**
- Snapshot Description: Input field for the description of the snapshot to be created

### Delete EBS Snapshot

This plugin will delete an EBS snapshot for the first volume attached to an EC2 instance

**Inputs:**
- Snapshot Description: Input field for the description of the snapshot to be deleted

## Installation

Plug-in workflow steps are supported with Commander release 7.0.2 and higher. 

See [Adding plug-in workflow steps](https://docs.embotics.com/Commander/Using-Plug-In-WF-Steps.htm#Adding) in the Commander documentation to learn how to install this package. 

## Return codes

### Generic return codes

- 0 successful snapshot operation
- 1 No snapshots found
- 2 No snapshot with specified description found
- 3 Unable to delete snapshot within 60 seconds
- 4 Generic error, see comments

## Logging
To change the logging level, add the following named loggers to the Log4j configuration file located at: 

`<vcommander-install>\tomcat\common\classes\log4j2.xml` 

+ **JsonPath Extract** 
    + Loggers:
      + `<Logger level="DEBUG" name="plugin.aws.ebs.snapshots"/>`
