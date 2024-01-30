#!/bin/bash
#-------------------------------------------------------------------------------
# Library of common GIT functionality.
#  
# Import Sample Code:
# <pre>
# if [[ ! -f ~/lib/git_lib.sh ]]; then
#   echo "ERROR: Missing git_lib.sh library"
#   exit
# fi
# source ~/lib/git_lib.sh
# </pre>  
#  
# version: 2023.5.24  
#-------------------------------------------------------------------------------

# main branch name regex
# @var regex
RGX_MAIN='^(master|main|trunk)$'

# list of common main branch names
# @var array
declare -a MAIN_BRANCHES=("master" "main" "trunk")

# stash trim size
# @var int
TRIM_SIZE=3

# Check if a directory is a git working directory
# 
# @param repoDir - path to local git project
# @return - 0 (zero) when true, 1 otherwise
function isGitDir {
  local theDir=$1
  if [ -d "${theDir}" ] && [ -d "${theDir}/.git" ]; then
    return 0
  fi
  return 1
}

# Get the current repo branch name
# 
# @param repoDir - path to local git project
# @output - current branch name of project, written to standard out
function gitBranchName {
  #//check if there are still more arguments where the number could be provided
  if (( $# > 0 )); then
    echo $(git -C "${1}" rev-parse --abbrev-ref HEAD)
  fi  
}

# Get the main branch name used by the specified repo  
# note: checks for one of (main, master, or trunk)
# 
# @param repoDir - path to local git project
# @return - 0 (zero) with successful matched main branch, 1 otherwise
# @output - main branch name used in the git project, writtent to standard out
function gitMainBranch {

  #//check for missing argument
  if (( $# == 0 )); then
    return 1
  fi
  
  #//test each branch name
  local branchName=""
  for branch in ${MAIN_BRANCHES[@]}; do
    branchName=$(git -C "${1}" branch -l "${branch}" | sed 's/^[* ] //')
    #//check for non-empty string
    if [[ -n "${branchName}" ]]; then
      echo "${branchName}"
      return 0
    fi
  done

  # branch not matched
  return 1
}

# Perform a fetch
# 
# @param repoDir - path to local git project
function gitFetch {
  if (( $# > 0 )); then
    git -C "${1}" fetch
  fi
}

# Perform a git pull on the repo
# 
# @param repoDir - path to local git project
function gitPull {
  if (( $# > 0 )); then
    git -C "${1}" pull
  fi
}

# Perform the stash list command and ouputs to standard output.
# You can capture output using command substitution "$( getStashList )"
# 
# @param repoDir - path to local git project
function gitStashList {
  if (( $# > 0 )); then
    git -C "${1}" stash list
  fi
}

# Perform a stash of code
# 
# @param repoDir - path to local git project
# @param message - message for the stash entry
function gitStash {
  if (( $# > 1 )); then
    git -C "${1}" stash -m "${2}"
  fi
}

# Perform a stash apply
# 
# @param repoDir - path to local git project
function gitApply {
  if (( $# > 0 )); then
    git -C "${1}" stash apply
  fi
}

# Perform a git stash show.
# You can capture output using substitution "$( getStashShow )"
# 
# @param repoDir - path to local git project
# @param index - optional index number of stash entry to show
function gitStashShow {
  if (( $# > 1 )); then
    git -C "${1}" stash show "stash@{${2}}"
    return
  fi
  
  if (( $# > 0 )); then
    git -C "${1}" stash show
  fi
}

# Trim stash entries from the end of the list down to the stash count specified
# 
# @param repoDir - path to local git project
# @param count - the number of stash entries that should remain after trim
function trimStash {
  local repoDir=$1
  local stashCount=$2
    
  #//get the last index position
  local stashIdx="$(( stashCount-1 ))"
  
  #//loop as long as index is greater than or equal to trim size  (ex. when trim 3, stop at index 2)
  while (( stashIdx >= TRIM_SIZE )); do
    echo "  Dropping index [$stashIdx]"
    
    #perform trim at current index
    git -C "${repoDir}" stash drop "stash@{${stashIdx}}"
  
    #//subtract one from the count to get to the next index to drop
    stashIdx="$(( stashIdx-1 ))"
  done
}

# Get revision counts comparing current working branch against the local master
# or if you specify the remote orign master.
# 
# @param repoDir - path to local git project
# @param remote - optional, TRUE to indicate counts against remote, local otherwise
# @output - two tab separated count numbers, indicating revision ahead and behind
function gitRevisionCounts {
  local repoDir=$1
  local doRemote=false
  
  #//check for remote option
  if (( $# > 1 )) && [ "${2^^}" = "REMOTE" ]; then
    doRemote=true
  fi
  
  #//get the repo's main branch
  local mainBranch=$(gitMainBranch "$1")
  
  if [ "$doRemote" = true ]; then 
    git -C "${repoDir}" rev-list --left-right --count HEAD..."origin/${mainBranch}"
  else
    git -C "${repoDir}" rev-list --left-right --count HEAD..."${mainBranch}"
  fi
}