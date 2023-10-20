#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will trim the stash of entries from the end/oldest down to
#  a specified number of entries.
#  
#  version: 2023.10.11
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//echo print colors
GRN='\033[0;32m'
YEL='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/git_lib.sh ~/lib/prompt.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//force trim without prompting
FORCE=false

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

# Print the usage information for this script to standard output.
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

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-h"
  addOption "-v"
  addOption "-f"
  addOption "-d" true
  addOption "-t" true
  
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

  # check for force trim, no prompt
  if hasArgument "-f"; then
    FORCE=true
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

  # check for depth
  if hasArgument "-t" ]; then
    numValue=$(getArgument "-t")
    log "  Depth Value: $numValue"
    if [[ $numValue =~ $RGX_NUM ]]; then
      TRIM_SIZE=$numValue
      log "  Trim Size: $TRIM_SIZE"
    fi
  fi
}

# Prompt user with option to perform trim, skip, or quit
function waitForInput {
  #//wait for input
  if promptYesNo "Perform Trim down to ${TRIM_SIZE}? [Y/N] or Q to Quit: "; then
    return 0
  else
    #//exit script if quit is entered
    log "  Input: ${REPLY}"
    if [ "${REPLY^^}" = "Q" ];  then
      logAll "Quitting Script"
      exit 0
    fi
    return 1
  fi
}

# Print out the stash list with color highliting depending on the amount of entries
# 
# @param repoDir - path to local git project
# @param stashList - the stash list array
# @param stashCount - number of stash entries
function printStashList {
  local repoDir=$1
  local stashList=$2
  local stashCount=$3
  
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

  logAll "${stashList}"
}

# Perform all the processing for a single repository
# 
# @param repoDir - path to local git project
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
logAll "DONE"
