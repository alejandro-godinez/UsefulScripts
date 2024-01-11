#!/bin/bash

#----------------------------------------------------------------
# This script will find the largest files for the specified
# directory recursively.  
# 
# 
# Dependencies:  
#   ../UsefulScripts/linux/lib/logging.sh  
# 
# version: 2023.3.20
#----------------------------------------------------------------

set -u #//error on unset variable
set -f #//turn off globbing so that our file filer doesn't expand to files

# use of associative arrays requires bash 4 and greater
if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need at least bash-4.0 to run this script."
  exit 1
fi

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh)
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
MAX_DEPTH=-1

#//numeric regex
RGX_NUM='^[0-9]+$'

# Print the usage information for this script to standard output.
function printHelp {
  echo "This script will find the largest files for the specified"
  echo "directory recursively."
  echo ""
  echo "Usage: "
  echo "  findLargestFiles.sh [path]"
  echo ""
  echo "  path - alternative to the working directory (default)"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -d num    Search depth (default recursive)"
  echo ""
  echo "  Example: findFileWidthText.sh \"hello\" \"*.txt\""
  echo "    - this will list '*.txt' files and search entries containing 'hello'"
  echo ""
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
   # initialize expected options
  addOption "-v"
  addOption "-h"
  addOption "-d" true
  
  # perform parsing of options
  parseArguments "$@"

  # printArgs
  # printRemArgs
  
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

#< - - - Main - - - >

#//process arguments
log "Processing input arguments..."
processArgs "$@"

#//print out the list of args that were not consumed by function (non-flag arguments)
argCount=0
if [[ -v REM_ARGS ]]; then
  argCount=${#REM_ARGS[@]}
  log "List Remaining Args: ${argCount}"
  for item in "${REM_ARGS[@]}"; do log "  ${item}"; done
fi

#//if dir is not supplied default to current path
if (( argCount > 0 )); then
  dir="${REM_ARGS[0]}"
else
  dir=$( pwd -P )
fi
log "DIR: ${dir}"

#// check if the directory exists
if [[ ! -d $dir ]]; then
  logAll "Specified path is not a directory: $dir"
  exit 1
fi

#// size, user, group, permissions, path
#columnFormat="%12s %u:%g\t%M\t%p\n"
#// size, user, path
columnFormat="%12s %u %p\n"

log "Column Format: $columnFormat"

#// size, user, path
if (( MAX_DEPTH > -1 )); then
  find $dir -mindepth 1 -maxdepth ${MAX_DEPTH} -type f -printf "$columnFormat" | sort -n | tail
else
  find $dir -mindepth 1 -type f -printf "$columnFormat" | sort -n | tail
fi
