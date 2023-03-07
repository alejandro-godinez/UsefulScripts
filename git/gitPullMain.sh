#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will perform a pull on each of the git project folders in the
#  current directory if it is pointing to the main branch.  The user will
#  be interrogated to confirm pull.
#
#  version: 2023.3.7
#
#  TODO:
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

GRN='\033[0;32m'
YEL='\033[1;33m'
NC='\033[0m' # No Color

DEBUG=false #//toggle debug output

#//prompt to perform pull on non main branches
PULL_ALL=FALSE

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

#//main branch names
RGX_MAIN='^master|main|trunk$'

function printHelp {
  echo "Usage: gitPullMain.sh [-h] [-v] [-a] [-d num]"
  echo "  Performs a pull on each git project directory that is in the main"
  echo ""
  echo "  Options:"
  echo "    -h      This help info"
  echo "    -v      Verbose/debug output"
  echo "    -a      Prompt to pull for all ALL branches"
  echo "    -d num    Search depth (default 1)"
}

function log {
  if [ "$DEBUG" = true ]; then
    echo "$1"
  fi
}

#//process the arguments for the script
function processArgs {
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
    
    #//check for ALL branch
    if [ "${arg^^}" = "-A" ]; then
      PULL_ALL=true
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
}

function waitForInput {
  local repoDir=$1
  local branch=$2

  #//wait for input
  if [[ $branch =~ $RGX_MAIN ]]; then
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

function gitPull {
  local repoDir=$1

  #//get current working branch
  branch=$(git -C $repoDir rev-parse --abbrev-ref HEAD)
  log "  Branch: ${branch}"

  #//skip if branch is not the main branch
  if [ ! "$PULL_ALL" = true ]; then
    if [[ ! $branch =~ $RGX_MAIN ]]; then
      log "  Not a main branch"
      return
    fi
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
processArgs "$@"

#//identify if current directory is a git project directory
currDir=$(pwd)
log "Current Dir: ${currDir}"

log "Checking current directory..."
if isGitDir "${currDir}"; then
  #// pull main branch
  log "  Performing the pull..."
  gitPull "${currDir}"

  exit 0
else
  log "  Not A Repo"
fi

#// get list of all directories at the current location
echo "Depth Search: $MAX_DEPTH"
for aDir in $( find -mindepth 1 -maxdepth $MAX_DEPTH -type d )
do
  log "Directory: ${aDir}"

  #//skip directories that are not git projects
  if ! isGitDir "${aDir}"; then
    log "  Not A Repo"
    continue
  fi

  #// pull main branch
  gitPull "${aDir}"

done
log "DONE"
