#!/bin/bash

#-----------------------------------------------------------
# This script will search the contents of tar gzip files
# in the specified directory for entries with matching
# specified search text.  
# 
# 
# Dependencies:  
#   ../UsefulScripts/linux/lib/logging.sh  
# 
# version: 2023.3.16
#-----------------------------------------------------------
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
  echo "  findFilesWithTextInTarGzip.sh <search> [filter]"
  echo ""
  echo "  search - the text in the file's name to search for"
  echo "  filter - file filter to list of files that will be searched."
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -d num    Search depth (default 1)"
  echo ""
  echo "  Example: findFilesWithTextInTarGzip.sh \"sometext\" \"2018*.tgz\""
  echo "    - this will search '2018*.tgz' files and search if any inernal contents contain 'sometext'"
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
  filterCommand+=("-iname" "${REM_ARGS[1]}")
else
  filterCommand+=("-iname" "*.tar.gz" "-o" "-iname" "*.tgz")
fi
log "File Filter: ${filterCommand[*]}"

#//obtain the current working directory
dir=$( pwd )
logAll "DIR: ${dir}"
if [[ ! -d $dir ]]; then
  logAll "Specified path is not a directory."
  exit 1
fi

#//list all file using the filter and loop through them
iter=0
for f in $(${filterCommand[@]})
do 
  #//keep track of iteration count and print status update indicator
  iter=$(( iter+1 ))
  if [[ $(( $iter%50 )) -eq 0 ]]; then
    logAllN "."
  fi 

  #//perform grep serch on the tar listing output and capture the located lines
  #result=$( zcat ${f} | strings | grep ${search} )
  result=$( zcat ${f} | grep -m 1 -a ${search} )

  #//check if grep found something (success)
  if [[ $? -eq 0 ]]; then
    logAll ""
    logAll "${f}"
    logAll "${result}"
  fi

done

logAll ""
logAll "DONE"
