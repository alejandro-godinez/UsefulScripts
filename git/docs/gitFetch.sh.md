<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [gitFetch.sh](../gitFetch.sh)

 This script will perform a fetch on each of the git project folders  
 in the current directory. 

 version: 2023.5.16 

 Usage:<br> 
 <pre> 
 gitFetch.sh [options] 
   -h           This help info 
   -v           Verbose/debug output 
   -d num       Search depth (default 1) 
 </pre> 

 Examples: 
 <pre> 
 // fet all repos in current dir 
 gitFetch.sh 

 // fetch all repos to 3 sub directories 
 gitFetch.sh -d 3 
 </pre> 


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() |  Print the usage information for this script to standard output.   |
| processArgs(args) |  Setup and execute the argument processing functionality imported from arguments.sh.   <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
| processRepo(repoDir) |  Perform a git fetch for the specific repo directory   <br><br><u><b>Args:</b></u><br>repoDir - path to local git project  <br> |
