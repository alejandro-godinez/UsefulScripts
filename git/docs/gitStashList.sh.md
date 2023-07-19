<small><i>Auto-generated using bashdoc.sh</i></small>
# [gitStashList.sh](../gitStashList.sh)

 This script will list the stash entries of each of the git project folders 
 in the current directory.
 
 version: 2023.3.21
 
 TODO:


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
| printStashList($1,$2) | Print out the stash list with color highliting depending on the amount of entries    <br><br><u>Args:</u><br>$1 - the local repo directory  <br>$2 - the stash list array  <br> |
