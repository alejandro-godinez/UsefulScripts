# git_lib.sh
  This library bash script is a collection of various common GIT functions.

## Variables:
| Variable | Description |
|----------|-------------|
| RGX_MAIN | Regular expression for matching common main branch names |
| TRIM_SIZE | number of stash entries that should remain after performing a trimStash function |

## Functions:
| Function | Description |
|----------|-------------|
| isGitDir(repoDir) | Check if a directory is a git working directory <br><br><u>Args:</u><br><i>repoDir - path to the git project</i><br><br><u>Returns:</u><i> 0 (zero) if path is a repo, 1 otherwise |
| gitBranchName(repoDir) | Get the current working repositories branch name <br><br><u>Args:</u><br><i>repoDir - path to the git project</i><br><br><u>Returns:</u><i> the branch name</i>|
| gitMainBranch(repoDir) | Get the main branch name used by the specified repo <br><br><u>Args:</u><br><i>repoDir - path to the git project</i><br><br><u>Returns:</u><i> the main branch that is used by the project</i>|
| gitFetch(repoDir) | Perform a fetch operation <br><br><u>Args:</u><br><i>repoDir - path to the git project</i><br><br><u>Returns:</u><i> standard output from 'git fetch' command</i>|
| gitPull(repoDir) | Perform a git pull on the repo <br><br><u>Args:</u><br><i>repoDir - path to the git project</i><br><br><u>Returns:</u><i> standard output from 'git pull' command</i>|
| gitStashList(repoDir) | Perform the stash list command and ouputs to standard output. <br><br><u>Args:</u><br><i>repoDir - path to the git project</i><br><br><u>Returns:</u><i> standard output from 'git stash list' command</i>|
| gitStash(repoDir,message) | Perform a stash of code<br><br><u>Args:</u><br><i>repoDir - path to the git project</i><br><i>message - the commit message</i><br><br><u>Returns:</u><i> standard output from 'git stash' command</i>
| gitApply(repoDir) | Perform a stash apply <br><br><u>Args:</u><br><i>repoDir - path to the git project</i><br><br><u>Returns:</u><i> standard output from 'git apply' command</i>|
| gitStashShow(repoDir,[index]) | perform a git stash show. <br><br><u>Args:</u><br><i>repoDir - path to the git project</i><br><i>index - optional, stash index to show, defaults to most recenty entry</i><br><br><u>Returns:</u><i> standard output from 'git stash list' command</i>|
| trimStash(repoDir,stashCount) | Trim stash entries from the end of the list down to the stash count specified <br><br><u>Args:</u><br><i>repoDir - path to the git project</i><br><i>stashCount - number of stash entries that should remain after trim</i>|
| gitRevisionCounts(repoDir,doRemote) | Get revision counts comparing current working branch against the local master or if you specify the remote orign master.<br><br><u>Args:</u><br><i>repoDir - path to the git project</i><br><i>doRemote - optional, indicator to get count against remote</i>|