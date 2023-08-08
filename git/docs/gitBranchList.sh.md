<small><i>Auto-generated using bashdoc.sh</i></small>
# [gitBranchList.sh](../gitBranchList.sh)

 This script will list the current branch for each of the git project folders
 in the current directory.

 version: 2023.5.4


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
| printRepoBranch($1) | Print the current branch of the specified directory  <br><br><u>Args:</u><br>$1 - repo directory  <br> |