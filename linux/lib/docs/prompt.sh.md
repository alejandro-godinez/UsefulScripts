<small><i>Auto-generated using bashdoc.sh</i></small>
# [prompt.sh](../prompt.sh)

 Library of common re-usable prompt methods.

Import Sample Code:
  <pre>
    if [[ ! -f ~/lib/prompt.sh ]]; then
      echo "ERROR: Missing prompt.sh library"
      exit
    fi
    source ~/lib/prompt.sh
  </pre>

Usage:
 <pre>
   # prompt for list of option
   if promptSelection "one" "two" "three" ; then
     selection=$REPLY
   fi
 </pre>


## Functions:
| Function | Description |
|----------|-------------|
| promptForInput(text) | Prompt for any user input without any validation.  User input is stored in the bash $REPLY variable  <br><br><u>Args:</u><br>text - prompt text <br><br><u>Output:</u><br>use input stored in $REPLY variable <br> |
| promptYesNo(text) | Prompt user for a yes or no response  <br><br><u>Args:</u><br>text - prompt text <br><br><u>Return:</u><br>0 (zero) when yes, 1 otherwise <br> |
| promptForInteger(text) | Prompt user for an integer number value User input is stored in the bash $REPLY variable  <br><br><u>Args:</u><br>text - prompt text <br><br><u>Return:</u><br>0 (zero) when input is valid integer, 1 otherwise <br> |
| promptSelection(options,text) | Prompt user to select from list User selection value is stored in the bash $REPLY variable  <br><br><u>Args:</u><br>options - list of options (all remaining arguments) <br>text - the prompt text <br><br><u>Return:</u><br>0 (zero) when selection from list is valid, 1 otherwise <br><br><u>Output:</u><br>use selection stored in $REPLY <br> |
