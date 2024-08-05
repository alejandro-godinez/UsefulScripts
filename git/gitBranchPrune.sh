#!/bin/bash

#-------------------------------------------------------------------------------
# This script will prune branches that are older than some date since
# last commit.
# 
# version: 2024.7.22
# 
# Usage:<br>
# <pre>
# gitBranchPrune.sh [options]
#   -h           This help info
#   -v           Verbose/debug output
#   -l           List branch info only
# </pre>
# 
# Examples:
# <pre>
# gitBranchPrune.sh
# gitBranchPrune.sh -l
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
GRN='\033[0;32m'
YEL='\033[1;33m'

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/strings.sh ~/lib/git_lib.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done


# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: gitBranchPrune.sh [-h] [-v]"
  echo "  Prunes branches locally that are older than some date since last commit"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -l        list branch age only"
  # echo "    -d num    Search depth (default 1)"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-v"      #verbose
  addOption "-h"      #help
  addOption "-l"      #list
  
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
}

# Print the column headers for branch information
function printHeader(){
  daysHeader="Days "
  dateHeader=$(padRight " Commit " 12 " ")
  nameHeader=" Branch name"
  logAll "${daysHeader}|${dateHeader}|${nameHeader}"
  logAll $(padRight "" 50 "-")
}
# Perform all the work for a single repository directory
# 
# @param repoDir - path to local git project
function processGitDirectory {
  local repoDir=$1
  #logAll "Repo: $repoDir"

  local today=$(date '+%Y-%m-%d')
  log "  Today Date: ${today}"
  local todaySec=$(date +%s -d "${today}")
  local daysSince

  #// branch list command outputs LF delimited lines
  IFS=$'\n'

  #// print headers
  printHeader

  #//get the branch list
  branchList=$(gitBranchList "${repoDir}")

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

    log "    Today Sec: $todaySec"
    commitSec=$(date +%s -d "${commitDate}")
    log "    Commit Sec: $commitSec"

    #// get days between two days: subtract and devide by 24*3600=86400
    daysSince=$(( (todaySec - commitSec ) / 86400 ))
    #daysSinceVal=$(padRight "${daysSince}" 5 " ")
    daysSinceVal=$(padLeft "${daysSince} " 5 " ")
    if (( daysSince > 90 )); then
      logAllN "${RED}${daysSinceVal}${NC}"
    elif (( daysSince > 60 )); then
      logAllN "${YEL}${daysSinceVal}${NC}"
    else
      logAllN "${GRN}${daysSinceVal}${NC}"
    fi
    logAll "| $branchLine"

    #// check if the list only option was provided
    if hasArgument "-l"; then
      continue
    fi

    #TODO: perform branch delete if older than days
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

#// 
currDir="./"
log "Current Dir: ${currDir}"

if isGitDir "${currDir}"; then
  log "Processing current directory..."

  processGitDirectory "${currDir}"  
fi
