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
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/strings.sh ~/lib/prompt.sh ~/lib/git_lib.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

# maximum days after which branch will be considered for pruning
PRUNE_DAYS=90
CAUTION_DAYS=45

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: gitBranchPrune.sh [options]"
  echo "  Prunes branches locally that are older than some date since last commit"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -l        list branch age only"
  echo "    -p num    Days after which branch will be deleted (default 90)"
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

  if hasArgument "-p"; then
    local numValue=$(getArgument "-d")
    log "  Prune Value: $numValue"
    if [[ $numValue =~ $RGX_NUM ]]; then
      setPruneDays $numValue
      log "  Max Depth: $PRUNE_DAYS"
      log "  Caution Days: $CAUTION_DAYS"
    fi
  fi
}

# Set the number of days after which a branch will be deleted. Also updates the
# caution date to half of the value provided.
# 
# @param days - number of days
function setPruneDays {
  PRUNE_DAYS=$1
  CAUTION_DAYS=$((PRUNE_DAYS / 2))
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
    if (( daysSince >= PRUNE_DAYS )); then
      logAllN "${RED}${daysSinceVal}${NC}"
    elif (( daysSince >= CAUTION_DAYS )); then
      logAllN "${YEL}${daysSinceVal}${NC}"
    else
      logAllN "${GRN}${daysSinceVal}${NC}"
    fi
    logAll "| $branchLine"

    #// check if the list only option was provided
    if hasArgument "-l"; then
      continue
    fi

    # check if branch is older then the maximum set number of days
    if (( daysSince >= PRUNE_DAYS )); then

      # confirm with user if they want to delete
      local promptText="Do you want to prun branch ${branchName}?"
      if promptYesNo "$promptText"; then
        # TODO: perform the delete the branch
        logAll " ${RED}DELETED${NC}"
      fi
    fi
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
