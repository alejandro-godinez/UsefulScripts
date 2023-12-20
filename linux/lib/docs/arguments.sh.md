<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [arguments.sh](../arguments.sh)

Library implementation of common script argument processing functionality. The
developer pre-defines the expected option codes along with indicator if the
option will need to have a value specified. After calling the parsing function
there are vaious getter functions to determine if option was specified.

Note: Any additional arguments that were not matched to expected option will
stored and can be access via the 'REM_ARGS' variable


Import Sample Code:
  <pre>
    if [[ ! -f ~/lib/arguments.sh ]]; then
      echo "ERROR: Missing arguments.sh library"
      exit
    fi
    source ~/lib/arguments.sh
  </pre>
 
Usage:
 <pre>
   # define expected options
   addOption "-v"
   addOption "-file" true

   # run processing of argument
   parseArguments "$@"

   # check and get argument value
   if hasArgument "-file"; then
     file=$(getArgument "-file")
   fi
 </pre>

Limitation Notes:
- option codes should start with dash (ie. -v, -test, -filePath)
- arguments without dash will be interpreted as value for the previous option


## Functions:
| Function | Description |
|----------|-------------|
| hasOption(option) | Check if the specified option key exists    <br><br><u><b>Args:</b></u><br>option - the option name  <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise  <br> |
| addOption(option,&nbsp;needsValue) | Add an option code/name that should be captured. If a value needs to be  provided with the argument set value indicator to true.    <br><br><u><b>Args:</b></u><br>option - the option name  <br>needsValue - true/false indicator that option will have argument (optional)  <br><br><u><b>Return:</b></u><br>0 (zero) when added, 1 otherwise  <br> |
| optionNeedsVal(option) | Check if the option needs to have a value provided following the code    <br><br><u><b>Args:</b></u><br>option - the option name  <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise  <br> |
| setArgument(option,&nbsp;value) | Sets the argument value for the specified option    <br><br><u><b>Args:</b></u><br>option - the option name  <br>value - the argument value  <br> |
| getArgument(option) | Get the argument value for an option name.    <br><br><u><b>Args:</b></u><br>option - the option name  <br><br><u><b>Return:</b></u><br>0 (zero) with valid option, 1 otherwise.  <br><br><u><b>Output:</b></u><br>the argument value  <br> |
| hasArgument(option) | Check if the specified option was parsed from the arguments.  This checks if the value is not 'false'    <br><br><u><b>Args:</b></u><br>option - the option name  <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise  <br> |
| startsWithDash(text) | Check if text starts with dash    <br><br><u><b>Args:</b></u><br>text - the text to check  <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise  <br> |
| addToREM(arg) | Adds an entry to the argument remaining variable    <br><br><u><b>Args:</b></u><br>arg - argument value  <br> |
| parseArguments(args) | Parsing and processing of the argument list    <br><br><u><b>Args:</b></u><br>args - array of arguments, use "$@" from script call  <br> |
| printArgs() | Print to standard output the captured argument options and values   |
| printRemArgs() | Prints to standard output all the remaining arguments that were not match to a defined option   |
