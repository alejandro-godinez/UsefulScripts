<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [upcaseSql.sh](../upcaseSql.sh)

 This script will perform uppercase operation on any SQL keyword in the specified
 input file. A new copy of the script with '_ucase' in the name will be generated in the
 same directory.


 Notes:
 - small set of keywords is currently defined, still need to add more

 Usage:
 <pre>
 upcaseSql.sh [options] [files]
   -h        This help info
   -v        Verbose/debug output
 </pre>

 Usage Examples:
 <pre>
 upcaseSql.sh myscript.sql
 </pre>


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() |  Print the usage information for this script to standard output.  |
| processArgs(args) |  Setup and execute the argument processing functionality imported from arguments.sh.  <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script <br> |
| hasKeyword(line) |  Check if a line contains an sql keyword  <br><br><u><b>Args:</b></u><br>line - the line of text to test <br><br><u><b>Return:</b></u><br>exit value of zero indicates yes <br> |
| processFile(file) |  Perform all the work to uppercase keywords in speified file  <br><br><u><b>Args:</b></u><br>file - the sql script file to convert <br> |
