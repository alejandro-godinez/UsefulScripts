#!/bin/bash
 
#-------------------------------------------------------------------------------
# This script will print the list of branches available for the current git
# project folder sorted by the last commit date.
# 
# version: 2024.5.13
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

# use of associative arrays requires bash 4 and greater
if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need at least bash-4.0 to run this script."
  exit 1
fi

#//echo print colors
NC='\033[0m'       # No Color
RED='\033[0;31m'
GRN='\033[0;32m'
YEL='\033[1;33m'

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/git_lib.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: gitBranchList.sh [-h] [-v]"
  echo "  Prints the list of branches available in the current project directory sorted"
  echo "  in descending commit date order (newest first)."
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -a        Ascending order (oldest first)"
  # echo "    -d num    Search depth (default 1)"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-v"      #verbose
  addOption "-h"      #help
  addOption "-a"      #ascending order
  # addOption "-d" true #search depth number
  
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
#   if hasArgument "-d" ]; then
#     numValue=$(getArgument "-d")
#     log "  Depth Value: $numValue"
#     if [[ $numValue =~ $RGX_NUM ]]; then
#       MAX_DEPTH=$numValue
#       log "  Max Depth: $MAX_DEPTH"
#     fi
#   fi
}

# Perform all the processing for a single repository
# 
# @param repoDir - path to local git project
function processGitDirectory {
  local repoDir=$1

  #//check if ascending order argument was specified
  if hasArgument "-a"; then
    gitBranchList "${repoDir}" true
  else
    gitBranchList "${repoDir}"
  fi
  
}

#< - - - Main - - - >
# @break

#//enable logging library escapes
escapesOn

#//process arguments
processArgs "$@"

#//identify if current directory is a git project directory
#currDir=$(pwd)
currDir="./"
log "Current Dir: ${currDir}"
if isGitDir "${currDir}"; then

  log "Processing current directory..."
  processGitDirectory "${currDir}"

  #logAll "DONE"
  #exit 0
fi