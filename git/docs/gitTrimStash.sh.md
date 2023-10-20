<small><i>Auto-generated using bashdoc.sh</i></small>
# [gitTrimStash.sh](../gitTrimStash.sh)

 This script will trim the stash of entries from the end/oldest down to
 a specified number of entries.
 
 version: 2023.10.11


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs(args) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u>Args:</u><br>args - array of argument values provided when calling the script  <br> |
| waitForInput() | Prompt user with option to perform trim, skip, or quit   |
| printStashList(repoDir,stashCount,stashList) | Print out the stash list with color highliting depending on the amount of entries    <br><br><u>Args:</u><br>repoDir - path to local git project  <br>stashCount - number of stash entries  <br>stashList - the stash list array  <br> |
| processGitDirectory(repoDir) | Perform all the processing for a single repository    <br><br><u>Args:</u><br>repoDir - path to local git project  <br> |
