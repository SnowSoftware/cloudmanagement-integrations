# Pause Workflow Plug-in Step Package

This package contains a Commander workflow plug-in step to pause a workflow so it can be resumed later

It was designed specifically for use in *Pause & Resume*.

## Changelog

**Version 1.0:** Initial version.

## Plug-in steps in this package
+ Pause

*Example: Pause*

### Pause
**Purpose:** *To Pause the execution of a workflow so it can be resumed later*

**Workflows supporting this plug-in step:** *Bulleted list of supported workflow types*

  * Change Request Approval
  * Change Request Completion
  * New Request Approval
  * VM Completion
  * Service Completion
  * Virtual Service Completion
  * Custom Component Completion
  * Cloud Template Completion
  * Shared VM Completion
  * Command

## Installation

Workflow plug-in steps are supported with Commander release 7.0 and higher. 

See [Adding Workflow Plug-in Steps](https://docs.embotics.com/commander/Using-Plug-In-WF-Steps.htm#Adding) in the Commander documentation to learn how to install this package. 

## Return codes

### Generic return codes

+ **0** - *Step completed successfully*

## Logging
To change the logging level, add the following named loggers to the Log4j configuration file located at: 

<vcommander-install>\tomcat\common\classes\log4j2.xml 

*Examples*:

+ **General Utilities**
    + Loggers:
      + `<Logger level="DEBUG" name="wfplugins.pause"/>`

## Notes
*Optional section; bulleted list of limitations, troubleshooting, etc.*
