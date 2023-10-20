#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will get a count of revisions ahead and behind from master both
#  against local and remote.
#  
#  version: 2023.5.12
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//echo print colors
NC='\033[0m'       # No Color
RED='\033[0;31m'
YEL='\033[1;33m'
U_CYN='\033[4;36m'       # underline Cyan

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

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: gitRevCount.sh [-h] [-v] [-d num]"
  echo "  Prints the stash list of each git project in the current directory."
  echo "  You can get detailed list of files changed by using the 'show' option."
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
  addOption "-h"
  addOption "-v"
  addOption "-d" true

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

# Get rev count for a specific repo directory
# 
# @param repoDir - path to local git project
function processRepo {
  local repoDir=$1
  
  mainBranch=$(gitMainBranch $repoDir)
  log "Main Branch: ${mainBranch}"
  branch=$(gitBranchName $repoDir)
  log "Current Branch: ${branch}"
  
  #//print local counts if current branch is not main
  if ! [[ $branch =~ $RGX_MAIN ]]; then
    localCounts=$(gitRevisionCounts $repoDir)
    logAll "${localCounts}\t${branch}->${mainBranch}  ${repoDir}"
  fi
  
  #//get and print remote counts
  remoteCounts=$(gitRevisionCounts $repoDir remote)
  logAll "${remoteCounts}\t${branch}->origin/${mainBranch}  ${repoDir}"
}

#< - - - Main - - - >

#//enable logging library escapes
escapesOn

#//check the command arguments
processArgs "$@"

logAll "${YEL}TIP: Perform a fetch for counts to be acurate${NC}"
logAll ""

logAll "${U_CYN}Ahead\tBehind\tBranch${NC}"

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
logAll ""
logAll "DONE"
