#!/bin/bash
 
#-------------------------------------------------------------------------------
# This script will print the list of branches available for the current git
# project folder sorted by the last commit date. Options are provided to list
# the remote branches and in ascending order.
# 
# version: 2024.8.4
#
# Usage:<br>
# <pre>
# gitBranchList.sh [options]
#   -h           This help info
#   -v           Verbose/debug output
#   -a           Ascending order (oldest first)
#   -r           List remote branches
# </pre>
# 
# Examples:
# <pre>
# gitBranchList.sh
# gitBranchList.sh -r -a
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
NC='\033[0m'       # No Color
RED='\033[0;31m'

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/git_lib.sh ~/lib/strings.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi

  # shellcheck disable=SC1090 # disable warning for dynamic source
  source "$lib"
done

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: gitBranchList.sh [options]"
  echo "  Prints the list of branches available in the current project directory sorted"
  echo "  in descending commit date order (newest first)."
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -a        Ascending order (oldest first)"
  echo "    -r        List remote branches"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-v"      #verbose
  addOption "-h"      #help
  addOption "-a"      #ascending order
  addOption "-r"      #remote banches
  
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
}

# Print the column headers for branch information
function printHeader(){
  local dateHeader
  dateHeader=$(padRight "Last Commit" 12 " ")

  local nameHeader=" Branch name"
  logAll "${dateHeader}|${nameHeader}"
  logAll "$(padRight "" 50 "-")"
}

# Perform all the processing for a single repository
# 
# @param repoDir - path to local git project
function processGitDirectory {
  local repoDir=$1
  local ascend=false
  local remote=false

  #//check if ascending order argument was specified
  if hasArgument "-a"; then
    ascend=true
  fi

  #//check if remote opton was specified
  if hasArgument "-r"; then
    remote=true
  fi

  #// branch list command outputs LF delimited lines
  IFS=$'\n'

  #// print headers
  printHeader

  branchList=$(gitBranchList "${repoDir}" $ascend $remote)

  for branchLine in $branchList; do
    log "Branch Line: $branchLine"

    #// parse branch line info into temp array
    IFS=' | ' read -r -a tempArr <<< "$branchLine"
    #// get commit date from temp array
    commitDate="${tempArr[0]}"
    
     #// get branch name from temp array
    branchName="${tempArr[1]}"
    log "  Branch Name: $branchName"
    log "  Commit Date: $commitDate"

    commitDate=$(padRight "$commitDate" 12 " ")
    logAll "$commitDate| $branchName"
  done

  #// reset IFS back to default
  unset IFS
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
