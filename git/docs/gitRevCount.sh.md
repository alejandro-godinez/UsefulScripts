<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [gitRevCount.sh](../gitRevCount.sh)

 This script will get a count of revisions ahead and behind from master both 
 against local and remote. 

 version: 2023.5.12 

 Usage:<br> 
 <pre> 
 gitRevCount.sh [options] 
   -h           This help info 
   -v           Verbose/debug output 
   -d num       Search depth (default 1) 
 </pre> 

 Examples: 
 <pre> 
 // list revision counts for repos in current directory 
 gitRevCount.sh 

 // list revision counts for all repos down to 3 sub directories 
 gitRevCount.sh -d 3 
 </pre> 


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() |  Print the usage information for this script to standard output.   |
| processArgs(args) |  Setup and execute the argument processing functionality imported from arguments.sh.   <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
| processRepo(repoDir) |  Get rev count for a specific repo directory   <br><br><u><b>Args:</b></u><br>repoDir - path to local git project  <br> |
