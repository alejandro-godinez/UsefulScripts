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

# import argument processing functionality
if [[ ! -f ~/lib/arguments.sh ]]; then
  echo -e "${RED}ERROR: Missing arguments.sh library${NC}"
  exit
fi
source ~/lib/arguments.sh

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

#//echo print colors
GRN='\033[0;32m'
NC='\033[0m' # No Color
U_CYN='\033[4;36m'       # Cyan

#//search depth
MAX_DEPTH=1

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: gitFetch.sh [-h] [-v] [-d num]"
  echo "  Performs a fetch on each git project in the current directory."
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -d num    Search depth (default 1)"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param $1 - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-v"      #verbose
  addOption "-h"      #help
  addOption "-d" true #search depth number

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

# Perform a git fetch for the specific repo directory
# 
# @param $1 - the local repo directory
function processRepo {
  local repoDir=$1
  logAll "${U_CYN}${repoDir}${NC}"
  
  #//get and print remote counts
  log "Performing fetch"
  gitFetch $repoDir
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
