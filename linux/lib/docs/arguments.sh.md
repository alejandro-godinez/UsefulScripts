<small><i>Auto-generated using bashdoc.sh</i></small>
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
| hasOption($1) | Check if the specified option key exists  <br><br><u>Args:</u><br>$1 - the option name <br> |
| addOption($1,$2) | Add an option code/name that should be captured. If a value needs to be provided with the argument set value indicator to true.  <br><br><u>Args:</u><br>$1 - the option name <br>$2 - argument value needed indicator true/false (optional) <br> |
| optionNeedsVal($1) | Check if the option needs to have a value provided following the code  <br><br><u>Args:</u><br>$1 - the option name <br> |
| setArgument($1,$2) | <br><br><u>Args:</u><br>$1 - the option name <br>$2 - the argument value <br> |
| getArgument($1) | Get the argument value for an option name  <br><br><u>Args:</u><br>$1 - the option name <br> |
| hasArgument($1) | Check if the specified option was parsed from the arguments. This checks if the value is not empty  <br><br><u>Args:</u><br>$1 - the option name <br> |
| startsWithDash($1) | Check if text starts with dash  <br><br><u>Args:</u><br>$1 - the text to check <br> |
| addToREM() |  |
| parseArguments($1) | Parsing and processing of the argument list  <br><br><u>Args:</u><br>$1 - array of arguments, use "$@" from script call <br> |
| printArgs() | Print to standard output the captured argument options and values  |
| printRemArgs() | Prints to standard output all the remaining arguments that were not match to a defined option  |
