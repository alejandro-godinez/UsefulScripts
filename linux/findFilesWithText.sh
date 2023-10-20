#!/bin/bash
#-----------------------------------------------------------
# This script will search the contents of file in
# sub-directories from the working path for content that
# matches the specified search text.
# 
# 
# Dependencies:  
#   ../UsefulScripts/linux/lib/logging.sh  
# 
# version: 2023.3.16
#-----------------------------------------------------------

set -u #//error on unset variable
set -f #//turn off globbing so that our file filer doesn't expand to files

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
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

# Print the usage information for this script to standard output.
function printHelp {
  echo "This script will search the contents of file in"
  echo "sub-directories from the working path for content that"
  echo "matches the specified search text."
  echo ""
  echo "Usage: "
  echo "  findFilesWithText.sh <search> [filter]"
  echo ""
  echo "  search - the text in the file's name to search for"
  echo "  filter - additional limit to the list of tgz files that will be searched."
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -d num    Search depth (default 1)"
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
else
  #log "No Process Arguments Identified"
  printHelp
  exit 0
fi

#//check to make sure expected number of arguments were specified
log "Checking correct number of arguments..."
if (( argCount < 1 )); then
  logAll "  ERROR: Missing arguments"
  exit 0
fi

#//get and check for valid line range
search="${REM_ARGS[0]}"
log "Search: ${search}"

#//define default filter command arguments
filterCommand=("find" "-mindepth" "1" "-maxdepth" "${MAX_DEPTH}" "-type" "f" )

#//add file name filter option if provided
if (( argCount > 1 )); then
  filterCommand+=("-name" "${REM_ARGS[1]}")
fi
log "File Filter: ${filterCommand[*]}"

for f in $(${filterCommand[@]})
do 
  #//perform grep search on file and capture the located lines
  result=$( grep -m 1 "${search}" ${f} )
  if [ ! -z "${result// }" ]; then
    logAll "${f}"
  fi
done

logAll "DONE"