<!-- Auto-generated using bashdoc.sh -->
# [bashdoc.sh](bashdoc.sh)

Parse documentation comments from bash script and generate markdown

@version 1.0.0

Supported Function Formats:
- name() { }
- function name { }
- function name() { }


Supported Keywords:<br>
- @param - Specifies the parameters of a method.<br>

Limitation Notes:
- Comments lines cannot be empty, add a space to signal continuation of content 


TODO:<br>
- @author - Specifies the author of the class, method, or field.
- @version - Specifies the version of the class, method, or field.
- @return - Specifies the return value of a method.
- @see - Specifies a link to another class, method, or field.

Sample:
<pre>
#!/bin/bash
#-------------------------------------------
# This is the script description section
#-------------------------------------------

# This function does work
# @param $1 - the first parameter
function doWork() {
}

</pre>


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Process and capture the common execution options from the arguments used when  running the script. All other arguments specific to the script are retained  in array variable.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
| isComment($1) | Determine if text is a comment   <br><br><u>Args:</u><br>$1 - text to test with regex for match  <br> |
| isHeader($1) | Determine if text is a special header section indicator   <br><br><u>Args:</u><br>$1 - text to test with regex for match  <br> |
| isKeyword($1) | Determine if text is one a keyword   <br><br><u>Args:</u><br>$1 - text to test with regex for match  <br> |
| isFunction($1) | Determine if text is a function   <br><br><u>Args:</u><br>$1 - text to test with regex for match  <br> |
| newLinesToSpace($1,$2,$3) | Replace newline characters (cr and lf) to space   <br><br><u>Args:</u><br>$1 - text to perform replacement  <br>$2 - other  <br>$3 - another  <br> |
| writeComments() | Write the accumulated comments to the output file   |
| writeCommentsFlat() | Write the accumulated comments to the output file trimmed of any newline   |
| writeFunctionParameters() | write out the accumulated function parameters   |
| writeParameterDescription() | write out the paramaters formatted for description in table   |