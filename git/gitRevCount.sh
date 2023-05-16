#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will get a count of revisions ahead and behind from master both
#  against local and remote.
#  
#  version: 2023.5.12
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//import logging functionality
if [[ ! -f ~/lib/logging.sh ]]; then
  echo "ERROR: Missing logging.sh library"
  exit
fi
source ~/lib/logging.sh

#//import git functionality
if [[ ! -f ~/lib/git_lib.sh ]]; then
  echo "ERROR: Missing git_lib.sh library"
  exit
fi
source ~/lib/git_lib.sh

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

#//echo print colors
YEL='\033[1;33m'
U_CYN='\033[4;36m'       # underline Cyan
NC='\033[0m' # No Color

#//indexed array of arguments that are not options/flags
declare -a ARG_VALUES

#//search depth
MAX_DEPTH=1


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

#-------------------------------
# Main
#-------------------------------
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
