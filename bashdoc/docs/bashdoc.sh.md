<small><i>Auto-generated using bashdoc.sh</i></small>
# [bashdoc.sh](../bashdoc.sh)

Parse documentation comments from bash script and generate markdown. The output file will
be saved in a 'docs' sub-directory unless the optional output directory option is
specified.  The output file name will be the name of the script with '.md' extension.
A relative path option (-r) can be used to fix the link to the script in the header.<br>

@version 2023.10.20

Supported Function Formats:
- name() { }
- function name { }
- function name() { }

Supported Keywords:
- @param - Describes the parameters of a method.
- @return - Describes the return code of a method. Normally 0 (success), 1 (error)
- @output - Describes the otuput of a method, normally written to standard output so it can be captured

Limitation Notes:
- keyword descriptions are limited to single lines, multiple instances can be used to append description.

TODO:<br>
- @author - Specifies the author of the class, method, or field.
- @version - Specifies the version of the class, method, or field.
- @see - Specifies a link to another class, method, or field.

Format Sample:
<pre>
#!/bin/bash
#-------------------------------------------
# This is the script description section
#-------------------------------------------

# This function does work
# @param paramOne - the first parameter
# @param paramTwo - the second parameter
# @return - 0 when true, 1 otherwise
# @output - the text ouput to standard out
function doWork() {
  echo "otuput value"
  return 0
}
</pre>

Usage:
<pre>
bashdoc.sh [options] [files]
  -h           This help info
  -v           Verbose/debug output
  -o path   optional, directory to which the output file will be saved
  -r path   optional, relative path to use for the script link in the header
</pre>

Usage Examples:
<pre>
Single:        bashdoc.sh script.sh"
Multiple:      bashdoc.sh script1.sh script2.sh script3.sh"
Output Dir:    bashdoc.sh -o /output/path *.sh"
Relative Link: bashdoc.sh -r '../' -o /output/path *.sh"
  Note: this is default
</pre>


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs(args) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
| isComment(text) | Determine if text is a comment    <br><br><u><b>Args:</b></u><br>text - text to test with regex for match  <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise  <br> |
| isEmptyComment(text) | Determine if text is a completly empty comment (nothing but spaces)   <br><br><u><b>Args:</b></u><br>text - text to test with regex for match  <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise  <br> |
| isHeader(text) | Determine if text is a special header section indicator    <br><br><u><b>Args:</b></u><br>text - text to test with regex for match  <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise  <br> |
| isKeyword(text) | Determine if text is one a keyword    <br><br><u><b>Args:</b></u><br>text - text to test with regex for match  <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise  <br> |
| isFunction(text) | Determine if text is a function    <br><br><u><b>Args:</b></u><br>text - text to test with regex for match  <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise  <br> |
| newLinesToSpace(text) | Replace newline characters (cr and lf) to space    <br><br><u><b>Args:</b></u><br>text - text to perform replacement  <br><br><u><b>Output:</b></u><br>the trimmed text on standard output  <br> |
| writeComments() | Write the accumulated comments to the output file   |
| writeCommentsFlat() | Write the accumulated comments to the output file trimmed of any newline   |
| writeFunctionParameters() | write out the accumulated function parameters   |
| writeParameterDescription() | write out the paramaters formatted for description in table   |
| writeReturnDescription() | write out the output description   |
| writeOutputDescription() | write out the output description   |
| parseBashScript(file) | perform all the work to parse the documentation from the specified bash script file    <br><br><u><b>Args:</b></u><br>file - the script file to parse  <br> |