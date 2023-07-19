<small><i>Auto-generated using bashdoc.sh</i></small>
# [gitRevCount.sh](../gitRevCount.sh)

 This script will get a count of revisions ahead and behind from master both
 against local and remote.
 
 version: 2023.5.12


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
| processRepo($1) | Get rev count for a specific repo directory    <br><br><u>Args:</u><br>$1 - the local repo directory  <br> |
