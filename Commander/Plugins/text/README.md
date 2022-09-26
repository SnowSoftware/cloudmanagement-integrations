# Text Processing Plug-in Workflow Step Package

This package contains a collection of plug-in workflow steps to manipulate text input.

It can be used in Commander workflow extension scenarios such as *Running a Kubernetes Best Practices Report*, which can be found on the [Embotics Support Knowledge Base](https://support.embotics.com/support/home). It can also be used outside of Commander scenarios.

## Changelog

**Version 1.2:**
 * Add Search and Replace

**Version 1.1:**
 * Fixed issue where plugin was hanging on failure.
 * Now creating output folder if it does not exist.

**Version 1.0:** Initial version. 

## Plug-in steps in this package
+ Text Input/Output
+ JsonPath Extract
+ RegEx Extract
+ XPath Extract
+ XSLT Transform
+ Search and Replace

### Text Input/Output 

**Purpose:** Creates structured text such as JSON, YAML or XML from the Commander workflow or service request context, using variable substitution from the given input and stores it as the step's output variable.

**Details:** Use this step to create JSON or XML as a workflow module's output, or to store text data as part of a workflow definition.

**Workflows supporting this plug-in step:**

- All

**Inputs:**

- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Template: Text area for input

### JsonPath Extract

**Purpose:** Extracts text from the provided input using json-path, returning the first matched text as the Commander variable `#{steps['Step Name'].output}`.

**Details:** See also: http://goessner.net/articles/JsonPath/

**Workflows supporting this plug-in step:**

  * All

**Inputs:**
- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Input: Input field for data piped in through a variable
- Expression: Input field for Json-Path expression. See https://github.com/json-path/JsonPath for reference information.

### RegEx Extract

**Purpose:** Extracts text from the provided input using a regular expression. 

**Details:** The step has 2 behaviors based on the regex pattern used to process the text:

1. No parenthetical groupings in the pattern: "http://[^\s]+"

   Returns the first match found in the input (ignores all other matches that may exist)

   For example, store the first URL found in the source text as the step output.
   Expression:_ "http://[^\s]+" 

   _Source:_ "Some text with a URL of http://www.domain.com, followed by another URL of http://www.another.com, and then more text."

   _Step Output:_ "http://www.domain.com"       

2. Parenthetical groupings exist in the pattern: 
  
   Return the first grouping of the first match found in the input (ignores other matches/groupings that may exist in the input)
   
   For example, store the domain/IP of the first URL found in the source text as step output. 
   
   _Expression:_ "https?://([^\s\/\:]+)"
   
   _Source:_ "Some text with a URL of http://www.domain.com followed by another URL of http://www.another.com and then more text."
   
   _Step Output:_ "www.domain.com"


**Workflows supporting this plug-in step:**

  * All

**Inputs:**

- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Input:  Input field for data piped in through a variable
- Expression:  Input field for a RegEx expression. See https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html for reference information.
     - **Examples:**
       - returning the first unbroken string of numbers found
         - [0-9]+
       - returning the second unbroken string of numbers found; using groupings
         - [0-9]+[^0-9]+([0-9]+)
       - returning the first raw domain/IP address embedded somewhere within a string, where it is prefixed as a http/s address; using groupings
         - https?://([^\s\/\:]+)


### XPath Extract

**Purpose:** Extracts text from the provided input using XPath.

**Details:** Outputs the first matched text as `#{steps['Step Name'].output}`.

**Workflows supporting this plug-in step:**

  * All

**Inputs:**

- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Input: Input field for data piped in through a variable
- Expression: Input field for an XPath expression. See https://www.w3schools.com/xml/xpath_syntax.asp for reference information.

### XSLT Transform

**Purpose:** Primarily designed to transform the output of Ant Junit tests into HTML, suitable for transmission through email.

**Details:** 

- Transforms the supplied input with a XSL stylesheet to the supplied output
- Step output `#{steps[*].output}` is set to the filename, if an output file was specified, or to the transformed output, if an output filename was not specified
- Uses the built-in Xalan XSLT support in the JDK

**Workflows supporting this plug-in step:**

  * All

**Inputs:**

- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Input: Input field for XML data to be transformed. The XML input can be a file or data piped in through a variable.
- Output: Input field to specify how to output the transformed data. This can be a path to a file saved on disk, or, if the field is left blank, the output will be stored as step output for access by other steps. 
- Stylesheet: Input field for an XSL stylesheet. This can be a path to a stylesheet saved on disk, or, if the field is left blank, `junit-noframes-emb.xsl` from Apache Ant is used. 
- Parameters: Text area for key=value pairs on parameters to pass in to the XSL stylesheet. Each key=value pair should be on a new line.

### Search and Replace

**Purpose:** Replace all instances of a given string with a new value.

**Details:** 

- Searches for the the specified text and replaces it with the new value

**Workflows supporting this plug-in step:**

  * All

**Inputs:**

- Step Name: Input field for the name of the step
- Step Execution: Drop-down that sets the step execution behavior. By default, steps execute automatically. However, you can set the step to execute only for specific conditions.
- Input: Input field for the data to be searched. The text input can be piped in through a variable.
- Search for: The text to search for.
- Replace with: The replacement value. 

## Installation

Plug-in workflow steps are supported with Commander release 7.0.2 and higher. 

See [Adding plug-in workflow steps](http://docs.embotics.com/commander/Using-Plug-In-WF-Steps.htm#Adding) in the Commander documentation to learn how to install this package. 

## Return codes

### Generic return codes

- 0 successful match (RegEx, XPath, JSONPath) or transformation (XSLT)
- 1 no match (RegEx, XPath, JSONPath)
- 2 error reading input or parsing expression
- 3 invalid or missing XSL file
- 4 error while transforming with XSLT
- 5 error while attempting to create output directory

## Logging
To change the logging level, add the following named loggers to the Log4j configuration file located at: 

`<vcommander-install>\tomcat\common\classes\log4j2.xml` 

+ **JsonPath Extract** 
    + Loggers:
      + `<Logger level="DEBUG" name="plugin.text.jsonpath"/>`
    
+ **Text Input/Output** 
    + Loggers:
      + `<Logger level="DEBUG" name="plugin.text.output"/>`
    
+ **RegEx Extract** 
    + Loggers:
      + `<Logger level="DEBUG" name="plugin.text.regex"/>`
    
+ **XPath Extract** 
    + Loggers:
      + `<Logger level="DEBUG" name="plugin.text.xpath"/>`
    
+ **XSLT Transform** 
    + Loggers:
      + `<Logger level="DEBUG" name="plugin.text.xslt"/>`
          
+ **Search and Replace** 
    + Loggers:
      + `<Logger level="DEBUG" name="plugin.text.replace"/>`
