#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will list the stash entries of each of the git project folders 
#  in the current directory.
#  
#  version: 2023.3.21
#  
#  TODO:
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//echo print colors
NC='\033[0m'       # No Color
GRN='\033[0;32m'
YEL='\033[1;33m'
RED='\033[1;31m'

#//import logging functionality
if [[ ! -f ~/lib/logging.sh ]]; then
  echo -e "${RED}ERROR: Missing logging.sh library${NC}"
  exit
fi
source ~/lib/logging.sh

#//import git functionality
if [[ ! -f ~/lib/git_lib.sh ]]; then
  echo "${RED}ERROR: Missing git_lib.sh library${NC}"
  exit
fi
source ~/lib/git_lib.sh

# import argument processing functionality
if [[ ! -f ~/lib/arguments.sh ]]; then
  echo -e "${RED}ERROR: Missing arguments.sh library${NC}"
  exit
fi
source ~/lib/arguments.sh

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//search depth
MAX_DEPTH=1
GIT_SHOW=false

#//numeric regex
RGX_NUM='^[0-9]+$'

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: gitStashList.sh [-h] [-v] [-s] [-d num]"
  echo "  Prints the stash list of each git project in the current directory."
  echo "  You can get detailed list of files changed by using the 'show' option."
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -s        perform a stash show for each line"
  echo "    -d num    Search depth (default 1)"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param $1 - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-h"
  addOption "-v"
  addOption "-s"
  addOption "-d" true

  # perform parsing of options
  parseArguments "$@"

  #printArgs
  #printRemArgs
  
  # check for help
  if hasArgument "-h"; then
    printHelp
    exit 0
  fi

  # check for vebose/debug
  if hasArgument "-v"; then
    DEBUG=true
  fi

  # check for show option
  if hasArgument "-s"; then
    GIT_SHOW=true
  fi
  
  # check for depth
  if hasArgument "-d" ]; then
    numValue=$(getArgument "-d")
    log "  Depth Value: $numValue"
    if [[ $numValue =~ $RGX_NUM ]]; then
      MAX_DEPTH=$numValue
      log "  Max Depth: $MAX_DEPTH"
    fi
  fi
}

# Print out the stash list with color highliting depending on the amount of entries
# 
# @param $1 - the local repo directory
# @param $2 - the stash list array
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
    logAll "${RED}${repoDir}${NC}"
  elif (( stashCount > 3 )); then
    logAll "${YEL}${repoDir}${NC}"
  elif (( stashCount > 0 )); then
    logAll "${GRN}${repoDir}${NC}"
  else
    log "  Stash is Empty"
    return
  fi
  
  #//if the show option was specified perform a stash show for each stash line
  if [ "$GIT_SHOW" = true ]; then
    stashNo=0
    while IFS= read -r line ; do
      logAll "${line}"
      gitStashShow "${repoDir}" "${stashNo}"
      stashNo=$((stashNo+1))
      logAll ""
    done <<< "${stashList}"
  else
    logAll "${stashList}"
  fi
  
  
}

#< - - - Main - - - >

#//enable logging library escapes
escapesOn

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
log "Depth Search: $MAX_DEPTH"
for aDir in $( find -mindepth 1 -maxdepth $MAX_DEPTH -type d )
do
  if isGitDir "${aDir}"; then
    log "  Getting the stash"
    stashList=$(gitStashList "${aDir}")

    log "  Printing stash output"
    printStashList "${aDir}" "${stashList}"
  fi
done
log "DONE"
