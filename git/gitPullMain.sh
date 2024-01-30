#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will perform a pull on each of the git project folders in the
#  current directory if it is pointing to the main branch.  The user will
#  be interrogated to confirm pull.
#  
#  version: 2024.1.4
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
U_CYN='\033[4;36m'

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/git_lib.sh ~/lib/prompt.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

#//prompt to perform pull on non main branches
PULL_ALL=FALSE
FORCE_PULL=FALSE

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: gitPullMain.sh [-h] [-v] [-a] [-d num]"
  echo "  Performs a pull on each git project in the current directory that is"
  echo "  is in a known 'main' branch (main, master, trunk, etc...).  You can"
  echo "  target all branchs by using the 'all' option."
  echo ""
  echo "  Options:"
  echo "    -h      This help info"
  echo "    -v      Verbose/debug output"
  echo "    -a      Prompt to pull for all ALL branches"
  echo "    -f      Don't prompt for pull (force)"
  echo "    -d num    Search depth (default 1)"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-v"
  addOption "-h"
  addOption "-a"
  addOption "-f"
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

  # check for ALL branch
  if hasArgument "-a"; then
    PULL_ALL=true
  fi

  # check for force pull, no prompt
  if hasArgument "-f"; then
    FORCE_PULL=true
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

# Ask user if they would like to perform pull for the repository/branch specified
# 
# @param repoDir - path to local git project
# @param branch - the branch of the repo directory
# @return - 0 (zero) when user answered yes, 1 otherwise
function waitForInput {
  local repoDir=$1
  local branch=$2

  #//wait for input
  if [[ $branch =~ $RGX_MAIN ]]; then
    logAll "${repoDir} - ${GRN}${branch}${NC}"
  else
    logAll "${repoDir} - ${YEL}${branch}${NC}"
  fi

  if promptYesNo "  Perform Pull? [Y/N] or Q to Quit: "; then
    return 0
  else
    #//exit script if quit is entered
    if [ "${REPLY^^}" = "Q" ];  then
      logAll "Quitting Script"
      exit 0  
    fi
    return 1
  fi
}

# Perform a git pull on the speicified local repository if it is the main branch.
# Other branches are allowed if the 'All' (-a) option was specified when executing.
# 
# @param repoDir - path to local git project
function gitPullMain {
  local repoDir=$1
  logAll "${U_CYN}${repoDir}${NC}"
  
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

  #// get the main branch
  mainBranch=$(gitMainBranch $repoDir)
  log "Main Branch: ${mainBranch}"

  #//get revision count info
  remoteCounts=$(gitRevisionCounts $repoDir remote)
  logAll "Rev [ahead behind]: ${remoteCounts}\t${branch}->origin/${mainBranch}"

  #//wait for input, unless force option was specified
  if [ ! "$FORCE_PULL" = true ]; then
    if ! waitForInput "${repoDir}" "${branch}"; then
      logAll "  Skipped"
      return
    fi
  fi 

  #//perform the git pull
  log "  Performing the pull..."
  gitPull $repoDir
}

#< - - - Main - - - >
# @break

#//enable logging library escapes
escapesOn

#//check the command arguments
processArgs "$@"

#//identify if current directory is a git project directory
currDir=$(pwd)
logAll "Current Dir: ${currDir}"

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
logAll "Depth Search: $MAX_DEPTH"
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
