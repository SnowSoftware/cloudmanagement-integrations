# SaltStack Community Workflow Plug-in Step Package

This package contains a collection of Commander community workflow plug-in steps for integrating with SaltStack.

## Changelog

**Version 1.0:** Initial version.

## Plug-in steps in this package
+ Apply State
+ Run Module Function

### Scenarios
See [here](https://github.com/Embotics/Scenarios/tree/master/Apply-SaltStack-State) for an example usage scenario.

### Apply State
**Purpose:** Apply Salt state to a target

**Workflows supporting this plug-in step:** All

**Inputs:**
* Salt URL
* Credentials
* Auth Module
* Target
* State
* Pillar

### Run Module Function
**Purpose:** Run a salt module function on the target

**Inputs:** 
* Salt URL
* Credentials
* Auth Module
* Target
* Function
* Arguments


## Installation

Workflow plug-in steps are supported with Commander release 7.0 and higher. 

See [Adding Workflow Plug-in Steps](https://docs.embotics.com/commander/Using-Plug-In-WF-Steps.htm#Adding) in the Commander documentation to learn how to install this package. 

## Return codes
+ **0** - *Step completed successfully*
+ **10** - *Exception occurred while trying to make the call to Salt*
+ **20** - *Minion or master returned an error*
+ **30** - *Failed to parse input*
+ **40** - *Failed to connect to the SaltStack API server*

## Logging
To change the logging level, add the following named loggers to the Log4j configuration file located at: `<vcommander-install>\tomcat\common\classes\log4j2.xml`


+ Loggers:
  + `wfplugins.saltstack.workflow` - Workflow step operations
  + `wfplugins.saltstack.client` - Communication with the SaltStack API

*Example:* `<Logger level="DEBUG" name="wfplugins.saltstack"/>` - Will capture debug messages from both the workflow and client operations.

## Notes
* To use this plugin you must have a SaltStack API server visible to the Commander host
* This plugin was tested with the CherryPy-based `salt-api` server. See [here](https://docs.saltstack.com/en/latest/ref/netapi/all/salt.netapi.rest_cherrypy.html) for details.
