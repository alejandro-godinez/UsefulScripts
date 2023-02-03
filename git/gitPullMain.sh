#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will perform a pull on each of the git project folders in the
#  current directory if it is pointing to the main branch.  The user will
#  be interrogated to confirm pull.
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

GRN='\033[0;32m'
YEL='\033[1;33m'
NC='\033[0m' # No Color

DEBUG=false #//toggle debug output

#//main branch name used
MAIN_BRANCH="master"

function printHelp {
  echo "Usage: gitPullMain.sh [-hv]"
  echo "  Performs a pull on each git project directory that is in the main"
  echo ""
  echo "  Options:"
  echo "    -h      This help info"
  echo "    -v      Verbose/debug output"
}

function log {
  if [ "$DEBUG" = true ]; then
    echo "$1"
  fi
}

function waitForInput {
  local repoDir=$1
  local branch=$2

  #//wait for input
  if [ "$branch" = "${MAIN_BRANCH}" ]; then
    echo -e "${repoDir} - ${GRN}${branch}${NC}"
  else
    echo -e "${repoDir} - ${YEL}${branch}${NC}"
  fi

  read -p "  Perform Pull? [Y/N] or Q to Quit: "

  #//exit script if quit is entered
  log "  Input: ${REPLY}"
  if [ "${REPLY^^}" = "Q" ];  then
    echo "Quitting Script"
    exit 0
  elif [ "${REPLY^^}" = "Y" ];  then
    return 0
  else
    return 1
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

function gitPullMainOnly {
  local repoDir=$1

  #//get current working branch
  branch=$(git -C $repoDir rev-parse --abbrev-ref HEAD)
  log "  Branch: ${branch}"

  #//skip if branch is not the main branch
  if [ "$branch" != "${MAIN_BRANCH}" ]; then
    log "Not ${MAIN_BRANCH}"
    return 1
  fi

  #//wait for input
  if ! waitForInput "${repoDir}" "${branch}"; then
    echo "  Skipped"
    return
  fi

  #//perform the git pull
  log "  Performing the pull..."
  git -C $repoDir pull
}

#-----------------------------
# Main
#-----------------------------

#//check the command arguments
for arg in "$@"
do
  log "Argument ${arg^^}"

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

log "Checking current directory..."
if isGitDir "${currDir}"; then
  #// pull main branch
  log "  Performing the pull..."
  gitPullMainOnly "${currDir}"

  exit 0
else
  log "  Not A Repo"
fi

#// get list of all directories at the current location
for aDir in $( find -mindepth 1 -maxdepth 1 -type d )
do
  log "Directory: ${aDir}"

  #//skip directories that are not git projects
  if ! isGitDir "${aDir}"; then
    log "  Not A Repo"
    continue
  fi

  #// pull main branch
  gitPullMainOnly "${aDir}"

done
log "DONE"
