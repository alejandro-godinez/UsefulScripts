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
| promptForInput($1) | Prompt for any user input without any validation.  User input is stored in the bash $REPLY variable  @return - exit value of zero indicates no error <br><br><u>Args:</u><br>$1 - prompt text <br> |
| promptYesNo($1) | Prompt user for a yes or no response  @return - exit value of zero indicates yes (bash no error) <br><br><u>Args:</u><br>$1 - prompt text <br> |
| promptForInteger($1) | Prompt user for an integer number value User input is stored in the bash $REPLY variable  @return - exit value of zero indicates valid (no error) <br><br><u>Args:</u><br>$1 - prompt text <br> |
| promptSelection() | Prompt user to select from list User selection value is stored in the bash $REPLY variable  @param $1..n - array of options @return - exit value of zero indicates valid selection (no error)  |
