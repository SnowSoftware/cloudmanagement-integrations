# wfplugins-awsrunoscommand Workflow Plug-in Step Package

This package contains a Commander workflow plug-in step to execute Guest OS commands on Windows and Linux EC2 Instances in AWS. 
This step makes uses of the AWS SSM toolkit and requires a set of prerequisites be fufilled before it will function. See the AWS SSM documentation for details: https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent.html

## Changelog

**Version 1.0:** Initial version.

## Plug-in steps in this package
+ Execute Guest OS Command (AWS)

### Execute Guest OS Command (AWS)
**Purpose:** Execute Guest OS commands using Poweshell on Windows and BASH on Linux against AWS EC2 instances.

**Workflows supporting this plug-in step:**

  * Change Request Completion
  * VM Completion
  * Command

**Inputs:**
  * Command: text of the command to execute on the target VM.

## Installation

Workflow plug-in steps are supported with Commander release 7.0 and higher. 

See [Adding Workflow Plug-in Steps](https://docs.embotics.com/commander/Using-Plug-In-WF-Steps.htm#Adding) in the Commander documentation to learn how to install this package. 

## Return codes

### Generic return codes
+ **0** - *Step completed successfully*
+ **All Other Returns** - *Step produced an error, see Workflow Comments for error details*

## Logging
To change the logging level, add the following named loggers to the Log4j configuration file located at: 

<vcommander-install>\tomcat\common\classes\log4j2.xml 

*Examples*:

+ **General Utilities**
    + Loggers:
      + `<Logger level="DEBUG" name="wfplugins.awsrunoscommand"/>`

