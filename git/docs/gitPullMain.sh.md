<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [gitPullMain.sh](../gitPullMain.sh)

 This script will perform a pull on each of the git project folders in the 
 current directory if it is pointing to the main branch.  The user will 
 be interrogated to confirm pull. 

 version: 2024.1.4 

 Usage:<br> 
 <pre> 
 gitPullMan.sh [options] 
   -h           This help info 
   -v           Verbose/debug output 
   -a           Prompt to pull for all ALL branches" 
   -f           Don't prompt for pull (force)" 
   -d num       Search depth (default 1)" 
 </pre> 

 Examples: 
 <pre> 
 // pull main branch with prompt in current directory 
 gitPullMain.sh 

 // no prompt pull all repos to 3 sub directories 
 gitPullMain.sh -d 3 -f 
 </pre> 


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() |  Print the usage information for this script to standard output.   |
| processArgs(args) |  Setup and execute the argument processing functionality imported from arguments.sh.   <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
| waitForInput(repoDir,&nbsp;branch) |  Ask user if they would like to perform pull for the repository/branch specified   <br><br><u><b>Args:</b></u><br>repoDir - path to local git project  <br>branch - the branch of the repo directory  <br><br><u><b>Return:</b></u><br>0 (zero) when user answered yes, 1 otherwise  <br> |
| gitPullMain(repoDir) |  Perform a git pull on the speicified local repository if it is the main branch.   Other branches are allowed if the 'All' (-a) option was specified when executing.   <br><br><u><b>Args:</b></u><br>repoDir - path to local git project  <br> |
