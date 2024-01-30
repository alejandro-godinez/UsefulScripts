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

#//number range values
RGX_RANGE='^[0-9]+([,][0-9]+)?$'

# Print the usage information for this script to standard output.
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

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-v"
  addOption "-h"
  
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
}

#< - - - Main - - - >
# @break

#//process arguments
log "Processing input arguments..."
processArgs "$@"

#//print out the list of args that were not consumed by function (non-flag arguments)
argCount=0
if [[ -v REM_ARGS ]]; then
  argCount=${#REM_ARGS[@]}
  log "List Remaining Args: ${argCount}"
  for item in "${REM_ARGS[@]}"; do log "  ${item}"; done
else
  #log "No Process Arguments Identified"
  printHelp
  exit 0
fi

#//get and check for valid line range
lineRange=${REM_ARGS[0]}
if [[ ! "$lineRange" =~ $RGX_RANGE ]]; then
  logAll "  ERROR: Range value is invalid: \"$lineRange\""
  exit 1
fi
log "Range: ${lineRange}"

#//get and check if specified file does not exist
file=${REM_ARGS[1]}
if [[ ! -f  $file ]]; then
  logAll "  ERROR: File specified was not found"
  exit 1
fi
log "FILE: ${file}"

log "Perform update..."
sed -i "${lineRange}"' s/^/#/' "${file}"
