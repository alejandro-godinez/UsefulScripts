#!/bin/bash

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