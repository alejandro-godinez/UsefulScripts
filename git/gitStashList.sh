#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will list the stash entries of each of the git project folders 
#  in the current directory.
#  
#  version: 2023.2.2
#
#  TODO:
#  - Add maxdepth variable and argument to control depth of search
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//echo print colors
GRN='\033[0;32m'
YEL='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

DEBUG=false #//toggle debug output

function printHelp {
  echo "Usage: gitStashList.sh [-hv]"
  echo "  Prints the stash list of each git project directory"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
}

function log {
  if [ "$DEBUG" = true ]; then 
    echo "$1"
  fi
}

#// check if a directory is a git working directory
function isGitDir {
  local theDir=$1
  log "The Dir: ${theDir}"
  if [ -d "${theDir}" ] && [ -d "${theDir}/.git" ]; then
    log "  Is Git Directory: TRUE"
    return 0
  fi
  log "  Is Git Directory: FALSE"
  return 1
}

#// perform the stash list command and ouputs to standard output
#//   you can capture output using command substitution "$( getStashList )"
function getStashList {
  local repoDir=$1
  git -C "${repoDir}" stash list
}

function printStashList {
  local repoDir=$1
  local stashList=$2
  local stashCount=0
  
  #//check for non-empty stash list and get a count of lines
  if [[ ! -z "${stashList// }" ]]; then
    stashCount=$( echo "${stashList}" | wc -l )
  fi
  
  log "  Stash Count: ${stashCount}"
  if (( stashCount > 5 )); then
    echo -e "${RED}${repoDir}${NC}"
  elif (( stashCount > 3 )); then
    echo -e "${YEL}${repoDir}${NC}"
  elif (( stashCount > 0 )); then
    echo -e "${GRN}${repoDir}${NC}"
  else
    log "  Stash is Empty"
    return
  fi

  echo "${stashList}"
}

#-------------------------------
# Main
#-------------------------------

#//check the command arguments
for arg in "$@"
do
  log "Argument ${arg^^}"
  
  if [ "${arg^^}" = "-V" ]; then
    DEBUG=true
  fi

  if [ "${arg^^}" = "-H" ]; then
    printHelp
    exit 0
  fi
done

#//identify if current directory is a git project directory
currDir=$(pwd)
log "Current Dir: ${currDir}"

log "Checking current directory..."
if isGitDir "${currDir}"; then

  log "  Getting the stash"
  stashList=$(getStashList "${currDir}")

  log "  Printing stash output"
  printStashList "${currDir}" "${stashList}"

  exit 0
fi

#//get list of all directories at the current location
for aDir in $( find -mindepth 1 -maxdepth 1 -type d )
do
  if isGitDir "${aDir}"; then
    log "  Getting the stash"
    stashList=$(getStashList "${aDir}")

    log "  Printing stash output"
    printStashList "${aDir}" "${stashList}"
  fi
done
echo "DONE"
