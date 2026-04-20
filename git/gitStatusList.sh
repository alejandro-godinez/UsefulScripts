#!/bin/bash
#-------------------------------------------------------------------------------
# This script will show the current status, in short form of each of the 
# project in the current directory
# 
# version: 2025.8.13
#
# Usage:<br>
# <pre>
# gitStatusList.sh [options]
#   -h           This help info
#   -v           Verbose/debug output
#   -d num       Search depth (default 1)
# </pre>
# 
# Examples:
# <pre>
# // show repo status for repos in current directory
# gitStatusList.sh
# 
# // show repo status for all repos down to 3 sub directories
# gitStatusList.sh -d 3
# </pre>
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
GRN='\033[0;32m'
YEL='\033[1;33m'
U_CYN='\033[4;36m'

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/git_lib.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi

  # shellcheck disable=SC1090 # disable warning for dynamic source
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
    # shellcheck disable=SC2034 # disable warning for unused variable, DEBUG is sourced from logging.sh
    DEBUG=true
  fi

  # check for depth
  if hasArgument "-d"; then
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
  
  #//print out the repo path and branch
  logAllN "${U_CYN}${repoDir}${NC} - "
  branch=$(gitBranchName "${repoDir}")
  log "  Branch: ${branch}"
  if [[ $branch =~ $RGX_MAIN ]]; then
    logAll "${GRN}${branch}${NC}"
  else
    logAll "${YEL}${branch}${NC}"
  fi

  #//call git status
  git -C "${repoDir}" status -s
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
  printStatus "${currDir}"
fi

logAll "Depth Search: $MAX_DEPTH"
declare -a repoList=()
mapfile -t repoList < <(find . -mindepth 1 -maxdepth "$MAX_DEPTH" -type d)

for aDir in "${repoList[@]}"
do
  if isGitDir "${aDir}"; then
    printStatus "${aDir}"
  fi
done
logAll "DONE"
