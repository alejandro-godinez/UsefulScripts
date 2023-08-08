<small><i>Auto-generated using bashdoc.sh</i></small>
# [spinner.sh](../spinner.sh)

Library implementation with function to print a rotating character in place
to demonstrate work being perform by long running script.


Import Sample Code:
  <pre>
    if [[ ! -f ~/lib/spinner.sh ]]; then
      echo "ERROR: Missing spinner.sh library"
      exit
    fi
    source ~/lib/spinner.sh
  </pre>
 
Usage:
 <pre>
   # spin the caracter one step
   spinChar
   # delete the spinner character at the end
   spinDel
 </pre>


## Functions:
| Function | Description |
|----------|-------------|
| setSpinner() | Set a different set of spinner characters  @param $@ - array of characters  |
| spinChar() | Display the next step in the character spinner  |
| spinDel() | delete the spinner character  |
