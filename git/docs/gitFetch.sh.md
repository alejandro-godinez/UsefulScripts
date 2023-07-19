<small><i>Auto-generated using bashdoc.sh</i></small>
# [gitFetch.sh](../gitFetch.sh)

 This script will perform a fetch on each of the git project folders 
 in the current directory.
 
 version: 2023.5.16


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
| processRepo($1) | Perform a git fetch for the specific repo directory    <br><br><u>Args:</u><br>$1 - the local repo directory  <br> |
