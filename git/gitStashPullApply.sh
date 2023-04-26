#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will perform a stash-pull-apply sequence of operations.
#  
#  version: 2023.3.21
#
#  TODO:
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

#//numeric regex
RGX_NUM='^[0-9]+$'

function printHelp {
  echo "Usage: gitStashPullApply.sh [-h] [-v] <message>"
  echo "  Perform a 'stash-pull-apply' sequence of operations to bring your branch"
  echo "  up to date and continue working on same change."
  echo ""
  echo "  message - the stash message"
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
    log "  Argument: ${arg}"
    
    #//the arguments to the next item
    shift 
    
    #//check for verbose
    if [ "${arg^^}" = "-V" ]; then
      DEBUG=true
      continue
    fi
    
    #//check for help
    if [ "${arg^^}" = "-H" ]; then
      printHelp
      exit 0
    fi
    
    #//keep arguments that are not options or values from the option
    log "    > Adding $arg to rem arg list"
    ARG_VALUES+=("$arg")
  done
}

#-------------------------------
# Main
#-------------------------------

#//check the command arguments
processArgs "$@"

#//print out the list of args that were not consumed by function (non-flag arguments)
argCount=0
if [[ -v ARG_VALUES ]]; then
  argCount=${#ARG_VALUES[@]}
  log "List Remaining Args: ${argCount}"
  for item in "${ARG_VALUES[@]}"; do log "  ${item}"; done
else
  #log "No Process Arguments Identified"
  printHelp
  exit 0
fi

#//identify if current directory is a git project directory
currDir=$(pwd)
log "Current Dir: ${currDir}"

#//if the directory is not supplied default to current work directory
message="${ARG_VALUES[0]}"
log "  Message:  ${message}"

log "Checking current directory..."
if isGitDir "${currDir}"; then

  logAll "  Performing Stash..."
  gitStash "${currDir}" "${message}"

  logAll "  Performing pull..."
  gitPull "${currDir}"
  
  logAll "  Performing stash apply..."
  gitApply "${currDir}"
  
  exit 0
else
  echo "  ERROR: Not a git directory"
fi

echo "DONE"