<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [gitStashPullApply.sh](../gitStashPullApply.sh)

 This script will perform a stash-pull-apply sequence of operations. 

 version: 2023.3.21 

 Usage:<br> 
 <pre> 
 gitCurrentBranch.sh [options] 
   -h           This help info 
   -v           Verbose/debug output 
 </pre> 

 Examples: 
 <pre> 
 // list current branch for repos in current directory 
 gitStashPullApply.sh "some work was done" 
 </pre> 


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() |  Print the usage information for this script to standard output.   |
| processArgs(args) |  Setup and execute the argument processing functionality imported from arguments.sh.   <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
