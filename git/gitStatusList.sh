#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will show the current status, in short form of each of the 
#  project in the current directory
#  
#  version: 2023.5.23
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

# use of associative arrays requires bash 4 and greater
if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need at least bash-4.0 to run this script."
  exit 1
fi

#//echo print colors
NC='\033[0m' # No Color
RED='\033[1;31m'
U_CYN='\033[4;36m'       # Cyan

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/git_lib.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: gitStatusList.sh [-h] [-v] [-d num]"
  echo "  Prints the current status in short form for each of the projects found in the current directory"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -d num    Search depth (default 1)"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
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

# print the git status of the local repository
# 
# @param repoDir - path to local git project
function printStatus {
  local repoDir=$1
  
  logAll "${U_CYN}${repoDir}${NC}"
  git -C "${repoDir}" status -s
}

#< - - - Main - - - >

#//enable logging library escapes
escapesOn

#//process arguments
processArgs "$@"

#//identify if current directory is a git project directory
currDir=$(pwd)
log "Current Dir: ${currDir}"
if isGitDir "${currDir}"; then
  printStatus "${currDir}"
  logAll "DONE"
  exit 0
fi

logAll "Depth Search: $MAX_DEPTH"
for aDir in $( find -mindepth 1 -maxdepth $MAX_DEPTH -type d )
do
  if isGitDir "${aDir}"; then
    printStatus "${aDir}"
  fi
done
logAll "DONE"
