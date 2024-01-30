#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will perform a stash-pull-apply sequence of operations.
#  
#  version: 2023.3.21
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

# use of associative arrays requires bash 4 and greater
if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need at least bash-4.0 to run this script."
  exit 1
fi

#//echo print colors
NC='\033[0m' # No Color
GRN='\033[0;32m'
YEL='\033[1;33m'
RED='\033[1;31m'

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

#//numeric regex
RGX_NUM='^[0-9]+$'

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: gitStashPullApply.sh [-h] [-v] <message>"
  echo "  Perform a 'stash-pull-apply' sequence of operations to bring your branch"
  echo "  up to date and continue working on same change."
  echo ""
  echo "  message - the stash message"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-h"
  addOption "-v"

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

#< - - - Main - - - >
# @break

#//enable logging library escapes
escapesOn

#//check the command arguments
processArgs "$@"

#//identify if current directory is a git project directory
currDir=$(pwd)
log "Current Dir: ${currDir}"

#//if the directory is not supplied default to current work directory
message="${REM_ARGS[0]}"
log "  Message:  ${message}"

log "Checking current directory..."
if isGitDir "${currDir}"; then

  logAll "  Performing Stash..."
  gitStash "${currDir}" "${message}"

  logAll "  Performing pull..."
  gitPull "${currDir}"
  
  logAll "  Performing stash apply..."
  gitApply "${currDir}"
  
  exit 0
else
  logAll "  ERROR: Not a git directory"
fi

logAll "DONE"
