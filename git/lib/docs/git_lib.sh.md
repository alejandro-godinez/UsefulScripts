<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [git_lib.sh](../git_lib.sh)

 Library of common GIT functionality.

 Import Sample Code:
 <pre>
 if [[ ! -f ~/lib/git_lib.sh ]]; then
   echo "ERROR: Missing git_lib.sh library"
   exit
 fi
 source ~/lib/git_lib.sh
 </pre>  

 version: 2023.5.24  


## Variables:
| Variables | Type | description |
|-----------|------|-------------|
| RGX_MAIN | regex |  main branch name regex  |
| MAIN_BRANCHES | array |  list of common main branch names  |
| TRIM_SIZE | int |  stash trim size  |

## Functions:
| Function | Description |
|----------|-------------|
| isGitDir(repoDir) |  Check if a directory is a git working directory  <br><br><u><b>Args:</b></u><br>repoDir - path to local git project <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise <br> |
| gitBranchName(repoDir) |  Get the current repo branch name  <br><br><u><b>Args:</b></u><br>repoDir - path to local git project <br><br><u><b>Output:</b></u><br>current branch name of project, written to standard out <br> |
| gitMainBranch(repoDir) |  Get the main branch name used by the specified repo    note: checks for one of (main, master, or trunk)  <br><br><u><b>Args:</b></u><br>repoDir - path to local git project <br><br><u><b>Return:</b></u><br>0 (zero) with successful matched main branch, 1 otherwise <br><br><u><b>Output:</b></u><br>main branch name used in the git project, writtent to standard out <br> |
| gitFetch(repoDir) |  Perform a fetch  <br><br><u><b>Args:</b></u><br>repoDir - path to local git project <br> |
| gitPull(repoDir) |  Perform a git pull on the repo  <br><br><u><b>Args:</b></u><br>repoDir - path to local git project <br> |
| gitStashList(repoDir) |  Perform the stash list command and ouputs to standard output.  You can capture output using command substitution "$( getStashList )"  <br><br><u><b>Args:</b></u><br>repoDir - path to local git project <br> |
| gitStash(repoDir,&nbsp;message) |  Perform a stash of code  <br><br><u><b>Args:</b></u><br>repoDir - path to local git project <br>message - message for the stash entry <br> |
| gitApply(repoDir) |  Perform a stash apply  <br><br><u><b>Args:</b></u><br>repoDir - path to local git project <br> |
| gitStashShow(index,&nbsp;repoDir) |  Perform a git stash show.  You can capture output using substitution "$( getStashShow )"  <br><br><u><b>Args:</b></u><br>index - optional index number of stash entry to show <br>repoDir - path to local git project <br> |
| trimStash(count,&nbsp;repoDir) |  Trim stash entries from the end of the list down to the stash count specified  <br><br><u><b>Args:</b></u><br>count - the number of stash entries that should remain after trim <br>repoDir - path to local git project <br> |
| gitRevisionCounts(remote,&nbsp;repoDir) |  Get revision counts comparing current working branch against the local master  or if you specify the remote orign master.  <br><br><u><b>Args:</b></u><br>remote - optional, TRUE to indicate counts against remote, local otherwise <br>repoDir - path to local git project <br><br><u><b>Output:</b></u><br>two tab separated count numbers, indicating revision ahead and behind <br> |
