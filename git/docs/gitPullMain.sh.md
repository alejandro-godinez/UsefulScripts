<small><i>Auto-generated using bashdoc.sh</i></small>
# [gitPullMain.sh](../gitPullMain.sh)

 This script will perform a pull on each of the git project folders in the
 current directory if it is pointing to the main branch.  The user will
 be interrogated to confirm pull.
 
 version: 2023.4.7


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
| waitForInput() | Ask user if they would like to perform pull for the repository/branch specified    param $1 - the local repo directory  param $2 - the branch of the repo directory   |
| gitPullMain($1) | Perform a git pull on the speicified local repository if it is the main branch.  Other branches are allowed if the 'All' (-a) option was specified when executing.    <br><br><u>Args:</u><br>$1 - the local repo directory  <br> |