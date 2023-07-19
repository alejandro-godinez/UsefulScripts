<small><i>Auto-generated using bashdoc.sh</i></small>
# [comment.sh](../comment.sh)

This script will add a comment "#" to the start of the line number(s)
specified.  


Dependencies:  
  ../UsefulScripts/linux/lib/logging.sh  

TODO:  
  - don't add comment to line that already has comment  
  - add option to remove comment from lines  

version: 2023.3.16


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Process and capture the common execution options from the arguments used when  running the script. All other arguments specific to the script are retained  in array variable.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
