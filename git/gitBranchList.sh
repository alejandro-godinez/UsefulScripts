#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will list the current branch for each of the git project folders 
#  in the current directory.
#
#  version: 2023.2.7
#
#  TODO:
#  - Define list of pottential main branchs instead of single 
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//echo print colors
GRN='\033[0;32m'
YEL='\033[1;33m'
NC='\033[0m' # No Color

#//toggle debug output
DEBUG=false 

#//main branch name used
MAIN_BRANCH="master"

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

function printHelp {
  echo "Usage: gitBranchList.sh [-h] [-v] [-d num]"
  echo "  Prints the current branch of each git project directory"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -d num    Search depth (default 1)"
}

function log {
  if [ "$DEBUG" = true ]; then 
    echo "$1"
  fi
}

#// check if a directory is a git working directory
function isGitDir {
  local theDir=$1
  log "  The Dir: ${theDir}"
  if [ -d "${theDir}" ] && [ -d "${theDir}/.git" ]; then
    log "  Is Git Directory: TRUE"
    return 0
  fi
  log "  Is Git Directory: FALSE"
  return 1
}

function printRepoBranch {
  local repoDir=$1

  #//print out the repot path and branch
  echo -n "${repoDir} - "
  branch=$(git -C "${repoDir}" rev-parse --abbrev-ref HEAD)
  log "  Branch: ${branch}"
  if [ "$branch" = "${MAIN_BRANCH}" ]; then
    echo -e "${GRN}${branch}${NC}"
  else
    echo -e "${YEL}${branch}${NC}"
  fi

}

#-------------------------------
# Main
#-------------------------------

#//check the command arguments
log "Arg Count: $#"
while (( $# > 0 )); do
  arg=$1
  
  #//check for verbose
  if [ "${arg^^}" = "-V" ]; then
    DEBUG=true
  fi
  
  log "Arg Count: $#"
  log "Argument: ${arg^^}"

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
  
  #//shift to next argument
  shift
done

#//identify if current directory is a git project directory
currDir=$(pwd)
log "Current Dir: ${currDir}"
if isGitDir "${currDir}"; then
  printRepoBranch "${currDir}"
  echo "DONE"
  exit 0
fi

#//get list of all directories at the current location
echo "Depth Search: $MAX_DEPTH"
for aDir in $( find -mindepth 1 -maxdepth $MAX_DEPTH -type d )
do
  log "Directory: ${aDir}"
  if isGitDir "${aDir}"; then
    printRepoBranch "${aDir}"
  fi
done
echo "DONE"
