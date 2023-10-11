<small><i>Auto-generated using bashdoc.sh</i></small>
# [bashdoc.sh](bashdoc.sh)

Parse documentation comments from bash script and generate markdown. The output file will
be saved in the same directory unless the optional output directory option is
specified.  The output file name will be the name of the script with '.md' extension.
A relative path option (-r) can be used to fix the link to the script in the header.

@version 2023.10.11

Supported Function Formats:
- name() { }
- function name { }
- function name() { }


Supported Keywords:<br>
- @param - Specifies the parameters of a method.<br>
- @return - Specifies the return value of a method.

Limitation Notes:
- Comments lines cannot be empty, add a space to signal continuation of content  
<br>

TODO:<br>
- @author - Specifies the author of the class, method, or field.
- @version - Specifies the version of the class, method, or field.
- @see - Specifies a link to another class, method, or field.

Sample:
<pre>
#!/bin/bash
#-------------------------------------------
# This is the script description section
#-------------------------------------------

# This function does work
# @param $1 - the first parameter
# @return - some value
function doWork() {
}

</pre>


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.  |
| processArgs($1) | Setup and execute the argument processing functionality imported from arguments.sh.  <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script <br> |
| isComment($1) | <br><br><u>Args:</u><br>$1 - text to test with regex for match <br><br><u>Return:</u><br>0 (zero) when true, 1 otherwise <br> |
| isHeader($1) | <br><br><u>Args:</u><br>$1 - text to test with regex for match <br><br><u>Return:</u><br>0 (zero) when true, 1 otherwise <br> |
| isKeyword($1) | <br><br><u>Args:</u><br>$1 - text to test with regex for match <br><br><u>Return:</u><br>0 (zero) when true, 1 otherwise <br> |
| isFunction($1) | <br><br><u>Args:</u><br>$1 - text to test with regex for match <br><br><u>Return:</u><br>0 (zero) when true, 1 otherwise <br> |
| newLinesToSpace($1) | <br><br><u>Args:</u><br>$1 - text to perform replacement <br><br><u>Return:</u><br>trimmed text <br> |
| writeComments() | Write the accumulated comments to the output file  |
| writeCommentsFlat() | Write the accumulated comments to the output file trimmed of any newline  |
| writeFunctionParameters() | write out the accumulated function parameters  |
| writeParameterDescription() | write out the paramaters formatted for description in table  |
| writeReturnDescription() | write out the output description  |
| parseBashScript($1) | perform all the work to parse the documentation from the specified bash script file  <br><br><u>Args:</u><br>$1 - the script file to parse <br> |
