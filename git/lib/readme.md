# git_lib.sh
  This library bash script is a collection of various common GIT functions.

### Variables:
- RGX_MAIN - Regular expression for matching common main branch names
- TRIM_SIZE - number of stash entries that should remain after performing a trimStash function

## **isGitDir** (repoDir)
Check if a directory is a git working directory  

Arguments
1. repoDir - path to the git project

**Returns:** 0 (zero) if path is a repo, 1 otherwise

## **gitBranchName** (repoDir)
Get the current working repositories branch name

Arguments
1. repoDir - path to the git project

**Returns:** the branch name

## **gitMainBranch** (repoDir)
Get the main branch name used by the specified repo

Arguments
1. repoDir - Path to the git project

**Returns:** the main branch that that is used by the project

## **gitFetch** (repoDir)
Perform a fetch

Arguments
1. repoDir - Path to the git project

**Returns:** standard output from 'git fetch' command

## **gitPull** (repoDir)
Perform a git pull on the repo

Arguments
1. repoDir - Path to the git project

**Returns:** standard output from 'git pull' command

## **gitStashList** (repoDir)
Perform the stash list command and ouputs to standard output.

Arguments
1. repoDir - Path to the git project

**Returns:** standard output of 'git stash list' command

## **gitStash** (repoDir, message)
Perform a stash of code

Arguments
1. repoDir - Path to the git project
2. message - The commit message

**Returns:** standard output from 'git stash' command

## **gitApply** (repoDir)
Perform a stash apply

Arguments
1. repoDir - Path to the git project

**Returns:** standard output from 'stash apply' command

## **gitStashShow** (repoDir, [index])
perform a git stash show.

Arguments
1. repoDir - Path to the git project
2. index - Optional, stash index to show, defaul command uses most recent entry

## **trimStash** (repoDir, stashCount)
Trim stash entries from the end of the list down to the stash count specified

Arguments
1. repoDir - Path to the git project
2. stashCount - Number of stash entries that should reamin after trim

## **gitRevisionCounts** (repoDir, doRemote)
Get revision counts comparing current working branch against the local master or if you specify the remote orign master.

Arguments
1. repoDir - Path to the git project
2. doRemote - optional, indicator to get count against remote