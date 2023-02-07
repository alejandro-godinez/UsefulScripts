#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will trim the stash of entries from the end/oldest down to
#  a specified number of entries.
#  
#  version: 2023.2.7
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

#//toggle debug output
DEBUG=false 

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

#//main branch names
RGX_MAIN='^master|main|trunk$'


function printHelp {
  echo "Usage: gitTrimStash.sh [-h] [-v] [-d num]"
  echo "  Trims the stash list of entries from the end/oldest down to a specific number of entries"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -d num    Search depth (default 1)"
}

function log {
  if [ "$DEBUG" = true ]; then 
    echo "$1"
  fi
}

function waitForInput {
  #//wait for input 
  read -p "Perform Trim? [Y/N] or Q to Quit: "
  
  #//exit script if quit is entered
  log "  Input: ${REPLY}"
  if [ "${REPLY^^}" = "Q" ];  then
    echo "Quitting Script"
    exit 0
  elif [ "${REPLY^^}" = "Y" ];  then
    return 0
  else
    return 1
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
  local stashCount=$3
  
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

function trimStash {
  local repoDir=$1
  local stashCount=$2

  #//TODO: make trim size a command option/argument
  #//the number of stash entries that should remain after trimming
  local trimSize=3
    
  #//get the last index position
  local stashIdx="$(( stashCount-1 ))"
  
  #//loop as long as index is greater than or equal to trim size  (ex. when trim 3, stop at index 2)
  while (( stashIdx >= trimSize )); do
    echo "  Dropping index [$stashIdx]"
    
    #perform trim at current index
    git -C "${repoDir}" stash drop "stash@{${stashIdx}}"
  
    #//subtract one from the count to get to the next index to drop
    stashIdx="$(( stashIdx-1 ))"
  done
  
}

#-------------------------------
# Main
#-------------------------------

#//check the command arguments
log "Arg Count: $#"
while (( $# > 0 )); do
  arg=$1
  
  #//check for verbose
  if [ "${arg^^}" = "-V" ]; then
    DEBUG=true
  fi
  
  log "Arg Count: $#"
  log "Argument: ${arg^^}"

  #//check for help
  if [ "${arg^^}" = "-H" ]; then
    printHelp
    exit 0
  fi
  
  #//check for depth
  if [ "${arg^^}" = "-D" ]; then
  
    #//check if there are still more arguments where the number could be provided
    if (( $# > 1 )); then
      #//check the depth number from next argument
      numValue=$2
      log "  Depth Value: $numValue"
      
      if [[ $numValue =~ $RGX_NUM ]]; then
        MAX_DEPTH=$numValue
        log "  Max Depth: $MAX_DEPTH"
        
        #//shift number argument so it is not processed on next iteration
        shift
      fi
    else
      log "  No more arguments for number to exist"
    fi
  fi
  
  #//shift to next argument
  shift
done

#//identify if current directory is a git project directory
currDir=$(pwd)
log "Current Dir: ${currDir}"

log "Checking current directory..."
if isGitDir "${currDir}"; then

  log "Getting the stash"
  stashList=$(getStashList "${currDir}")
  
  #//check for non-empty stash list and get a count of lines
  stashCount=0
  if [[ ! -z "${stashList// }" ]]; then
    stashCount=$( echo "${stashList}" | wc -l )
  fi
  
  #//check if stash is empty
  if (( stashCount < 1 )); then
    log "  No Stash Found"
    exit 0
  fi
    
  log "Printing stash output"
  printStashList "${currDir}" "${stashList}" "${stashCount}"
  
  log "Prompting User:"
  if waitForInput ; then
    log "Performing Trim"
    trimStash "${currDir}" "${stashCount}"
  fi

  exit 0
fi

#//get list of all directories at the current location
for aDir in $( find -mindepth 1 -maxdepth $MAX_DEPTH -type d )
do
  if isGitDir "${aDir}"; then
    log "Getting the stash"
    stashList=$(getStashList "${aDir}")
    
    #//check for non-empty stash list and get a count of lines
    stashCount=0
    if [[ ! -z "${stashList// }" ]]; then
      stashCount=$( echo "${stashList}" | wc -l )
    fi
    
    #//check if stash is empty
    if (( stashCount < 1 )); then
      log "No Stash Found"
      continue
    fi
    
    log "Printing stash output"
    printStashList "${aDir}" "${stashList}" "${stashCount}"
    
    log "Prompting User:"
    if waitForInput; then
      log "Performing Trim"
      trimStash "${aDir}" "${stashCount}"
    fi
  fi
done
echo "DONE"
