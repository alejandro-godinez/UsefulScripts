#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will list the current branch for each of the git project folders
#  in the current directory.
# 
#  version: 2023.5.4
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

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: gitBranchList.sh [-h] [-v] [-d num]"
  echo "  Prints the current branch of each git project found in the current directory"
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

# Print the current branch of the specified directory
# @param repoDir - path to local git project
function printRepoBranch {
  local repoDir=$1

  #//print out the repot path and branch
  logAllN "${repoDir} - "
  branch=$(gitBranchName ${repoDir})
  log "  Branch: ${branch}"
  
  if [[ $branch =~ $RGX_MAIN ]]; then
    logAll "${GRN}${branch}${NC}"
  else
    logAll "${YEL}${branch}${NC}"
  fi
}

#< - - - Main - - - >
# @break

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
