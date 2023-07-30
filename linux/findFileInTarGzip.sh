#!/bin/bash

#-----------------------------------------------------------
# This script will search the contents of any '.tar.gz' file
# in the specified directory for entries with matching
# specified search text.
# 
# Dependencies:  
#   ../UsefulScripts/linux/lib/logging.sh  
# 
# version: 2023.3.16
#-----------------------------------------------------------

set -u #//error on unset variable

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
  echo "This script will search the contents of any '.tar.gz' file"
  echo "in the specified directory for entries with matching"
  echo "specified search text"
  echo ""
  echo "Usage: "
  echo "  findFileInTarGzip.sh [options] <search> [tgzFilter]"
  echo ""
  echo "  search - the text in the file's name to search for"
  echo "  tgzFilter - additional limit to the list of tgz files that will be searched."
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -d num    Search depth (default 1)"
  echo ""
  echo "Example: findFileInTarGzip.sh test.txt 2018"
  echo "  - this will list '*2018*.tar.gz' files and search entries containing 'test.txt'"
  echo ""
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param $1 - array of argument values provided when calling the script
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
logAll "Search: ${search}"


#//if filter is not supplied default to all '.tar.gz' files
if (( argCount > 1 )); then
  tgzFilter="*${REM_ARGS[1]}*.tar.gz"
else
  tgzFilter="*.tar.gz"
fi
log "FILTER: ${tgzFilter}"

#//obtain the current working directory
dir=$( pwd )
logAll "DIR: ${dir}"
if [[ ! -d $dir ]]; then
  logAll "  ERROR: Specified path is not a directory."
  exit 1
fi

#//list all file using the filter and loop through them
iter=0
logAll "Depth Search: $MAX_DEPTH"
for f in $( find ${dir} -mindepth 1 -maxdepth $MAX_DEPTH -name "${tgzFilter}" -type f )
do 
  #//keep track of iteration count and print status update indicator
  iter=$(( iter+1 ))
  if [[ $(( $iter%50 )) -eq 0 ]]; then
    logAllN "."
  fi 

  #//perform grep serch on the tar listing output and capture the located lines
  result=$( tar -tvf ${f} | grep ${search} )

  #//check if grep found something (success)
  if [[ $? -eq 0 ]]; then
    logAll ""
    logAll "${f}"
    logAll "${result}"
  fi

done

logAll ""
logAll "DONE"
