#!/bin/bash
#------------------------------------------------------------------------
# This script will add a comment "#" to the start of the line number(s)
# specified.
#
#
# Dependencies: 
#   ../UsefulScripts/linux/lib/logging.sh
#
# TODO:
#   - don't add comment to line that already has comment
#   - add option to remove comment from lines
#
# version: 2023.3.16
#-------------------------------------------------------------------------

set -u #//error on unset variable

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

#//number range values
RGX_RANGE='^[0-9]+([,][0-9]+)?$'

function printHelp {
  echo "This script will add a comment to the start of the line number(s) specified"
  echo ""
  echo "Usage: "
  echo "  comment <startLine>[,<endLine>] <file>"
  echo ""
  echo "  startLine     - the single line number to comment"
  echo "  endLine       - the ending lin enumber in a range to lines to comment"
  echo "  file          - the file to update"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo ""
  echo "  Example:"
  echo "    comment \"4,6\" file.txt"
  echo "     - Comment line numbers 4 thru 6 in file.txt"
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
else
  #log "No Process Arguments Identified"
  printHelp
  exit 0
fi

#//get and check for valid line range
lineRange=${ARG_VALUES[0]}
if [[ ! "$lineRange" =~ $RGX_RANGE ]]; then
  logAll "  ERROR: Range value is invalid: \"$lineRange\""
  exit 1
fi
log "Range: ${lineRange}"

#//get and check if specified file does not exist
file=${ARG_VALUES[1]}
if [[ ! -f  $file ]]; then
  logAll "  ERROR: File specified was not found"
  exit 1
fi
log "FILE: ${file}"

log "Perform update..."
sed -i "${lineRange}"' s/^/#/' "${file}"
