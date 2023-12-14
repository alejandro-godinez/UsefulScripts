<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [spinner.sh](.././linux/lib/spinner.sh)

Library implementation with function to print a rotating set of characters 
in place to demonstrate work being perform by long running script.


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
   # delete the spinner character(s) (clear line)
   spinDel
 </pre>


## Functions:
| Function | Description |
|----------|-------------|
| setSpinner(chars) | Set a different set of spinner characters    <br><br><u><b>Args:</b></u><br>chars - array of characters  <br> |
| spinChar() | Display the next step in the character spinner   |
| spinDel() | delete the spinner character by clearing the currnet line content   |
