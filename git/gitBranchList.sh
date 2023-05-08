#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will list the current branch for each of the git project folders 
#  in the current directory.
#
#  version: 2023.5.4
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
NC='\033[0m' # No Color

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

function printHelp {
  echo "Usage: gitBranchList.sh [-h] [-v] [-d num]"
  echo "  Prints the current branch of each git project found in the current directory"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -d num    Search depth (default 1)"
}

#//process the arguments for the script
function processArgs {
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
}

function printRepoBranch {
  local repoDir=$1

  #//print out the repot path and branch
  logAll -n "${repoDir} - "
  branch=$(gitBranchName ${repoDir})
  log "  Branch: ${branch}"
  
  if [[ $branch =~ $RGX_MAIN ]]; then
    logAll "${GRN}${branch}${NC}"
  else
    logAll "${YEL}${branch}${NC}"
  fi
}

#-------------------------------
# Main
#-------------------------------
#//enable logging library escapes
escapesOn

#//process arguments
processArgs "$@"


#//identify if current directory is a git project directory
currDir=$(pwd)
log "Current Dir: ${currDir}"
if isGitDir "${currDir}"; then
  printRepoBranch "${currDir}"
  logAll "DONE"
  exit 0
fi

#//get list of all directories at the current location
logAll "Depth Search: $MAX_DEPTH"
for aDir in $( find -mindepth 1 -maxdepth $MAX_DEPTH -type d )
do
  log "Directory: ${aDir}"
  if isGitDir "${aDir}"; then
    printRepoBranch "${aDir}"
  fi
done
logAll "DONE"
