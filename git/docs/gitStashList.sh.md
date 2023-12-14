<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [gitStashList.sh](.././git/gitStashList.sh)

 This script will list the stash entries of each of the git project folders 
 in the current directory.
 
 version: 2023.3.21


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs(args) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
| printStashList(repoDir,&nbsp;stashList) | Print out the stash list with color highliting depending on the amount of entries    <br><br><u><b>Args:</b></u><br>repoDir - path to local git project  <br>stashList - the stash list array  <br> |
