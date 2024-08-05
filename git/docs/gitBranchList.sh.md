<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [gitBranchList.sh](../gitBranchList.sh)

 This script will print the list of branches available for the current git 
 project folder sorted by the last commit date. Options are provided to list 
 the remote branches and in ascending order. 

 version: 2024.8.4 

 Usage:<br> 
 <pre> 
 gitBranchList.sh [options] 
   -h           This help info 
   -v           Verbose/debug output 
   -a           Ascending order (oldest first) 
   -r           List remote branches 
 </pre> 

 Examples: 
 <pre> 
 gitBranchList.sh 
 gitBranchList.sh -r -a 
 </pre> 


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() |  Print the usage information for this script to standard output.   |
| processArgs(args) |  Setup and execute the argument processing functionality imported from arguments.sh.   <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
| processGitDirectory(repoDir) |  Perform all the processing for a single repository   <br><br><u><b>Args:</b></u><br>repoDir - path to local git project  <br> |
