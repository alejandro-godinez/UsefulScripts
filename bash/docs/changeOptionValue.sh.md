<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
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
| processArgs(args) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
