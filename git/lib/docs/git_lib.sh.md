<small><i>Auto-generated using bashdoc.sh</i></small>
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
 project:  https://github.com/alejandro-godinez/UsefulScripts  


## Functions:
| Function | Description |
|----------|-------------|
| isGitDir($1) | Check if a directory is a git working directory    <br><br><u>Args:</u><br>$1 - the path to check for git project  <br><br><u>Return:</u><br>0 (zero) when true, 1 otherwise  <br> |
| gitBranchName($1) | Get the current repo branch name    <br><br><u>Args:</u><br>$1 - path to the local git project  <br><br><u>Return:</u><br>current branch name of project  <br> |
| gitMainBranch($1) | Get the main branch name used by the specified repo  note: checks for one of (main, master, or trunk)    <br><br><u>Args:</u><br>$1 - path to the local git project  <br><br><u>Return:</u><br>main branch name used in the git project  <br> |
| gitFetch($1) | Perform a fetch    <br><br><u>Args:</u><br>$1 - path to the local git project  <br> |
| gitPull($1) | Perform a git pull on the repo    <br><br><u>Args:</u><br>$1 - path to the local git project  <br> |
| gitStashList($1) | Perform the stash list command and ouputs to standard output.  You can capture output using command substitution "$( getStashList )"    <br><br><u>Args:</u><br>$1 - path to the local git project  <br> |
| gitStash($1,$2) | Perform a stash of code    <br><br><u>Args:</u><br>$1 - path to the local git project  <br>$2 - message for the stash entry  <br> |
| gitApply($1) | Perform a stash apply    <br><br><u>Args:</u><br>$1 - path to the local git project  <br> |
| gitStashShow($1,$2) | Perform a git stash show.  You can capture output using substitution "$( getStashShow )"    <br><br><u>Args:</u><br>$1 - path to the local git project  <br>$2 - optional index number of stash entry to show  <br> |
| trimStash($1,$2) | Trim stash entries from the end of the list down to the stash count specified    <br><br><u>Args:</u><br>$1 - the path to the local project  <br>$2 - the number of stash entries that should remain after trim  <br> |
| gitRevisionCounts($1,$2) | Get revision counts comparing current working branch against the local master  or if you specify the remote orign master.    <br><br><u>Args:</u><br>$1 - the path to the local project  <br>$2 - ["remote"] optional to indicate counts against remote, local otherwise  <br><br><u>Return:</u><br>two tab separated count numbers, indicating revision ahead and behind  <br> |
