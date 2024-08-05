<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [gitCurrentBranch.sh](../gitCurrentBranch.sh)

 This script will list the current branch for each of the git project folders 
 in the current directory. 

 version: 2023.5.4 

 Usage:<br> 
 <pre> 
 gitCurrentBranch.sh [options] 
   -h           This help info 
   -v           Verbose/debug output 
   -d num       Search depth (default 1) 
 </pre> 

 Examples: 
 <pre> 
 // list current branch for repos in current directory 
 gitCurrentBranch.sh 

 // list branch for all repos down to 3 sub directories 
 gitCurrentBranch.sh -d 3 
 </pre> 


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() |  Print the usage information for this script to standard output.   |
| processArgs(args) |  Setup and execute the argument processing functionality imported from arguments.sh.   <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
| printRepoBranch(repoDir) |  Print the current branch of the specified directory  <br><br><u><b>Args:</b></u><br>repoDir - path to local git project  <br> |
