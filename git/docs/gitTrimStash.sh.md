<small><i>Auto-generated using bashdoc.sh</i></small>
# [gitTrimStash.sh](../gitTrimStash.sh)

 This script will trim the stash of entries from the end/oldest down to
 a specified number of entries.
 
 version: 2023.3.13


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
| waitForInput() | Prompt user with option to perform trim, skip, or quit   |
| printStashList($1,$2,$3) | Print out the stash list with color highliting depending on the amount of entries    <br><br><u>Args:</u><br>$1 - the local repo directory  <br>$2 - the stash list array  <br>$3 - number of stash entries  <br> |
| processGitDirectory($1) | Perform all the processing for a single repository    <br><br><u>Args:</u><br>$1 - local repo directory  <br> |
