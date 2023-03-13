#!/bin/bash

#// check if a directory is a git working directory
function isGitDir {
  local theDir=$1
  #log "  The Dir: ${theDir}"
  if [ -d "${theDir}" ] && [ -d "${theDir}/.git" ]; then
    #log "  Is Git Directory: TRUE"
    return 0
  fi
  #log "  Is Git Directory: FALSE"
  return 1
}

#//get the current repo branch name
function gitBranchName {
  #//check if there are still more arguments where the number could be provided
  if (( $# > 0 )); then
    echo $(git -C "${1}" rev-parse --abbrev-ref HEAD)
  fi  
}