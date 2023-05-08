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

#//import logging functionality
if [[ ! -f ~/lib/logging.sh ]]; then
  echo "ERROR: Missing logging.sh library"
  exit
fi
source ~/lib/logging.sh

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

#//indexed array of arguments that are not options/flags
declare -a ARG_VALUES

#//search depth
MAX_DEPTH=-1

#//numeric regex
RGX_NUM='^[0-9]+$'

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
      if (( $# > 0 )); then
        #//check the depth number from next argument
        numValue=$1
        log "    Number Value: $numValue"
        
        if [[ $numValue =~ $RGX_NUM ]]; then
          MAX_DEPTH=$numValue
          log "    Max Depth: $MAX_DEPTH"
          
          #//shift number argument so it is not processed on next iteration
          shift
        else
          log "    !Not A Number"
        fi
      else
        log "    No more arguments for number to exist"
      fi
      continue
    fi
    
    #//keep arguments that are not options or values from the option
    log "    > Adding $arg to rem arg list"
    ARG_VALUES+=("$arg")
  done
}

#-------------------------------
# Main
#-------------------------------

#//process arguments
log "Processing input arguments..."
processArgs "$@"

#//print out the list of args that were not consumed by function (non-flag arguments)
argCount=0
if [[ -v ARG_VALUES ]]; then
  argCount=${#ARG_VALUES[@]}
  log "List Remaining Args: ${argCount}"
  for item in "${ARG_VALUES[@]}"; do log "  ${item}"; done
fi

#//if dir is not supplied default to current path
if (( argCount > 0 )); then
  dir="${ARG_VALUES[0]}"
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
