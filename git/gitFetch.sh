#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will perform a fetch on each of the git project folders 
#  in the current directory.
#  
#  version: 2023.5.16
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

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

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

#//echo print colors
GRN='\033[0;32m'
NC='\033[0m' # No Color
U_CYN='\033[4;36m'       # Cyan

#//indexed array of arguments that are not options/flags
declare -a ARG_VALUES

#//search depth
MAX_DEPTH=1


function printHelp {
  echo "Usage: gitFetch.sh [-h] [-v] [-d num]"
  echo "  Performs a fetch on each git project in the current directory."
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -f        Perform fetch on each repo"
  echo "    -d num    Search depth (default 1)"
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
    
    #//keep arguments that are not options or values from the option
    log "    > Adding $arg to rem arg list"
    ARG_VALUES+=("$arg")
  done
}

# Get rev count for a specific repo directory
#
# @param $1 - the local repo directory
function processRepo {
  local repoDir=$1
  logAll "${U_CYN}${repoDir}${NC}"
  
  #//get and print remote counts
  log "Performing fetch"
  gitFetch $repoDir
}

#-------------------------------
# Main
#-------------------------------
#//enable logging library escapes
escapesOn

#//check the command arguments
processArgs "$@"

#//identify if current directory is a git project directory
currDir=$(pwd)
log "Current Dir: ${currDir}"
log "Checking current directory..."
if isGitDir "${currDir}"; then
  processRepo ${currDir}
fi

log "Depth Search: $MAX_DEPTH"
for aDir in $( find -mindepth 1 -maxdepth $MAX_DEPTH -type d )
do
  if isGitDir "${aDir}"; then
    processRepo ${aDir}
  fi
done
log ""
log "DONE"
