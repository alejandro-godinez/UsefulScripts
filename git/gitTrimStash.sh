#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will trim the stash of entries from the end/oldest down to
#  a specified number of entries.
#  
#  version: 2023.3.13
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//import logging functionality
if [[ ! -f ~/lib/logging.sh ]]; then
  echo "ERROR: Missing logging.sh library"
  exit
fi
source ~/lib/logging.sh

#//import git functionality
if [[ ! -f ~/lib/git_lib.sh ]]; then
  echo "ERROR: Missing git_lib.sh library"
  exit
fi
source ~/lib/git_lib.sh

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//echo print colors
GRN='\033[0;32m'
YEL='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

#//force trim without prompting
FORCE=false

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

function printHelp {
  echo "Usage: gitTrimStash.sh [-h] [-v] [-f] [-d num] [-t num]"
  echo "  Trims the stash list of entries from the oldest (end) down to a specific number of entries."
  echo "  Use the trim size option to adjust number of remaining entries."
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -f        Force trim without prompting"
  echo "    -d num    Search depth (default 1)"
  echo "    -t num    Trim Size (default 3), keeps most recent"
}

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
    
      #//check for force
    if [ "${arg^^}" = "-F" ]; then
      FORCE=true
    fi
    
    #//check for options with numeric values
    if [ "${arg^^}" = "-D" ] || [ "${arg^^}" = "-T" ]; then
    
      #//check if there are still more arguments where the number could be provided
      if (( $# > 1 )); then
        #//check the depth number from next argument
        numValue=$2
        
        if [[ $numValue =~ $RGX_NUM ]]; then
          if [ "${arg^^}" = "-D" ]; then
            MAX_DEPTH=$numValue
            log "  Max Depth: $MAX_DEPTH"
          elif [ "${arg^^}" = "-T" ]; then
            TRIM_SIZE=$numValue
            log "  Trim Size: $TRIM_SIZE"
          fi
          
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

function waitForInput {
  #//wait for input 
  read -p "Perform Trim down to ${TRIM_SIZE}? [Y/N] or Q to Quit: "
  
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

function processGitDirectory {
  local repoDir=$1
  
  log "Getting the stash"
  stashList=$(gitStashList "${repoDir}")
  
  #//check for non-empty stash list and get a count of lines
  stashCount=0
  if [[ ! -z "${stashList// }" ]]; then
    stashCount=$( echo "${stashList}" | wc -l )
  fi
  
  #//check if stash has enough entries
  if (( stashCount <= TRIM_SIZE )); then
    log "  Not Enough Stash Entries"
    return
  fi
  
  log "Printing stash output"
  printStashList "${repoDir}" "${stashList}" "${stashCount}"
  
  log "Prompting User:"
  if [ "${FORCE}" = true ] || waitForInput; then
    log "Performing Trim"
    trimStash "${repoDir}" "${stashCount}"
  fi
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

  log "Processing current directory..."
  processGitDirectory "${currDir}"

  exit 0
fi

#//get list of all directories at the current location
for currDir in $( find -mindepth 1 -maxdepth $MAX_DEPTH -type d )
do
  if isGitDir "${currDir}"; then
  
    log "Processing current directory..."
    processGitDirectory "${currDir}"
    
  fi
done
echo "DONE"
