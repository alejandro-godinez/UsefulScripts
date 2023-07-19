<small><i>Auto-generated using bashdoc.sh</i></small>
# [changeOptionValue.sh](../changeOptionValue.sh)

This script will change the value of a standard name=value pair file
such as ini or config files.  

  Note: This is a simple implementation sections are not yet supported.  
        Duplicate keys under different sections will all be changed.


Dependencies:  
  ../UsefulScripts/linux/lib/logging.sh  

TODO:  
  - improve support for targetting values under sections  

version: 2023.5.25


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Process and capture the common execution options from the arguments used when  running the script. All other arguments specific to the script are retained  in array variable.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
