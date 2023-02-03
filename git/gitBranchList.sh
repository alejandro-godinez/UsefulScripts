#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will list the current branch for each of the git project folders 
#  in the current directory.
#
#  version: 2023.2.2
#
#  TODO:
#  - Add maxdepth variable and argument to control depth of search
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

DEBUG=false #//toggle debug output

#//main branch name used
MAIN_BRANCH="master"

function printHelp {
  echo "Usage: gitBranchList.sh [-hv]"
  echo "  Prints the current branch of each git project directory"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
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
for arg in "$@"
do
  log "Argument: ${arg^^}"
  
  if [ "${arg^^}" = "-V" ]; then
    DEBUG=true
  fi

  if [ "${arg^^}" = "-H" ]; then
    printHelp
    exit 0
  fi
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
for aDir in $( find -mindepth 1 -maxdepth 1 -type d )
do
  log "Directory: ${aDir}"
  if isGitDir "${aDir}"; then
    printRepoBranch "${aDir}"
  fi
done
echo "DONE"
