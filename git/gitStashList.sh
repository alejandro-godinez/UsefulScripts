#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will list the stash entries of each of the git project folders 
#  in the current directory.
#  
#  version: 2023.3.13
#
#  TODO:
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//import logging functionality
source ~/lib/logging.sh

#//import git functionality
source ~/lib/git_lib.sh

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//echo print colors
GRN='\033[0;32m'
YEL='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

function printHelp {
  echo "Usage: gitStashList.sh [-h] [-v]"
  echo "  Prints the stash list of each git project directory"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
}

#//process the arguments for the script
function processArgs {
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
processArgs "$@"

#//identify if current directory is a git project directory
currDir=$(pwd)
log "Current Dir: ${currDir}"

log "Checking current directory..."
if isGitDir "${currDir}"; then

  log "  Getting the stash"
  stashList=$(gitStashList "${currDir}")

  log "  Printing stash output"
  printStashList "${currDir}" "${stashList}"

  exit 0
fi

#//get list of all directories at the current location
echo "Depth Search: $MAX_DEPTH"
for aDir in $( find -mindepth 1 -maxdepth $MAX_DEPTH -type d )
do
  if isGitDir "${aDir}"; then
    log "  Getting the stash"
    stashList=$(gitStashList "${aDir}")

    log "  Printing stash output"
    printStashList "${aDir}" "${stashList}"
  fi
done
echo "DONE"
