#!/bin/bash

#//main branch name regex
RGX_MAIN='^master|main|trunk$'

#//stash trim size
TRIM_SIZE=3

#// check if a directory is a git working directory
function isGitDir {
  local theDir=$1
  if [ -d "${theDir}" ] && [ -d "${theDir}/.git" ]; then
    return 0
  fi
  return 1
}

#//get the current repo branch name
function gitBranchName {
  #//check if there are still more arguments where the number could be provided
  if (( $# > 0 )); then
    echo $(git -C "${1}" rev-parse --abbrev-ref HEAD)
  fi  
}

#//perform a git pull on the repo
function gitPull {
  if (( $# > 0 )); then
    git -C "${1}" pull
  fi
}

#// perform the stash list command and ouputs to standard output
#//   you can capture output using command substitution "$( getStashList )"
function gitStashList {
  if (( $# > 0 )); then
    git -C "${1}" stash list
  fi
}

#// perform a stash of code
function gitStash {
  if (( $# > 1 )); then
    git -C "${1}" stash -m "${2}"
  fi
}

function gitApply {
  if (( $# > 0 )); then
    git -C "${1}" stash apply
  fi
}

#// perform a stash show show the git stash
#   you can capture output using substitution "$( getStashShow )"
function gitStashShow {
  if (( $# > 1 )); then
    git -C "${1}" stash show "stash@{${2}}"
    return
  fi
  
  if (( $# > 0 )); then
    git -C "${1}" stash show
  fi
}

#//trim stash entries from the end of the list down to the stash count specified
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