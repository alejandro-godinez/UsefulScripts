#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will perform a pull on each of the git project folders in the
#  current directory if it is pointing to the main branch.  The user will
#  be interrogated to confirm pull.
#
#  version: 2023.4.7
#
#  TODO:
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
IFS=$'\n'

GRN='\033[0;32m'
YEL='\033[1;33m'
NC='\033[0m' # No Color
U_CYN='\033[4;36m'       # Cyan

#//indexed array of arguments that are not options/flags
declare -a ARG_VALUES

#//prompt to perform pull on non main branches
PULL_ALL=FALSE
FORCE_PULL=FALSE

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

function printHelp {
  echo "Usage: gitPullMain.sh [-h] [-v] [-a] [-d num]"
  echo "  Performs a pull on each git project directory that is in the main"
  echo ""
  echo "  Options:"
  echo "    -h      This help info"
  echo "    -v      Verbose/debug output"
  echo "    -a      Prompt to pull for all ALL branches"
  echo "    -f      Don't prompt for pull (force)"
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
    
    #//check for ALL branch
    if [ "${arg^^}" = "-A" ]; then
      PULL_ALL=true
      continue
    fi
    
    #//check for ALL branch
    if [ "${arg^^}" = "-F" ]; then
      FORCE_PULL=true
      continue
    fi
    
    #//check for depth
    if [ "${arg^^}" = "-D" ]; then
    
      #//check if there are still more arguments where the number could be provided
      if (( $# > 0 )); then
        #//check the depth number from next argument
        numValue=$1
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
      
      continue
    fi
    
    #//keep arguments that are not options or values from the option
    log "    > Adding $arg to rem arg list"
    ARG_VALUES+=("$arg")
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

function gitPullMain {
  local repoDir=$1
  logAll "${U_CYN}Repo Dir: ${repoDir}${NC}"
  
  #//get current working branch
  branch=$(gitBranchName $repoDir)
  log "  Branch: ${branch}"

  #//skip if branch is not the main branch
  if [ ! "$PULL_ALL" = true ]; then
    if [[ ! $branch =~ $RGX_MAIN ]]; then
      log "  Not a main branch"
      return
    fi
  fi

  #//wait for input, unless force option was specified
  if [ ! "$FORCE_PULL" = true ]; then
    if ! waitForInput "${repoDir}" "${branch}"; then
      echo "  Skipped"
      return
    fi
  fi 

  #//perform the git pull
  log "  Performing the pull..."
  gitPull $repoDir
}

#-----------------------------
# Main
#-----------------------------
escapesOn

#//check the command arguments
processArgs "$@"

#//print out the list of args that were not consumed by function (non-flag arguments)
argCount=0
if [[ -v ARG_VALUES ]]; then
  argCount=${#ARG_VALUES[@]}
  log "List Remaining Args: ${argCount}"
  for item in "${ARG_VALUES[@]}"; do log "  ${item}"; done
fi

#//identify if current directory is a git project directory
currDir=$(pwd)
echo "Current Dir: ${currDir}"

log "Checking current directory..."
if isGitDir "${currDir}"; then
  #// pull main branch
  log "  Performing the pull..."
  gitPullMain "${currDir}"

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
  gitPullMain "${aDir}"

done
log "DONE"
