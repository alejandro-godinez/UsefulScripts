<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [gitTrimStash.sh](../gitTrimStash.sh)

 This script will trim the stash of entries from the end/oldest down to 
 a specified number of entries. 

  version: 2023.10.11 

 Usage:<br> 
 <pre> 
 gitTrimStash.sh [options] 
   -h           This help info 
   -v           Verbose/debug output 
   -f           Force trim without prompting" 
   -d num       Search depth (default 1)" 
   -t num       Trim Size (default 3), keeps most recent" 
 </pre> 

 Examples: 
 <pre> 
 // perform trim with prompt on repos in current directory 
 gitTrimStash.sh 

 // perform trim with prompt on all repos down to 3 sub directories 
 gitTrimStash.sh -d 3 

 // perform trim w/o prompt down to 1 stash entry on repos in current directory 
 gitTrimStash.sh -f -t 1 
 </pre> 


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() |  Print the usage information for this script to standard output.   |
| processArgs(args) |  Setup and execute the argument processing functionality imported from arguments.sh.   <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
| waitForInput() |  Prompt user with option to perform trim, skip, or quit   |
| printStashList(repoDir,&nbsp;stashList,&nbsp;stashCount) |  Print out the stash list with color highliting depending on the amount of entries   <br><br><u><b>Args:</b></u><br>repoDir - path to local git project  <br>stashList - the stash list array  <br>stashCount - number of stash entries  <br> |
| processGitDirectory(repoDir) |  Perform all the processing for a single repository   <br><br><u><b>Args:</b></u><br>repoDir - path to local git project  <br> |
