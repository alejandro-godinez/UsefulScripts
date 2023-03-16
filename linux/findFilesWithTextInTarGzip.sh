#!/bin/bash

#-----------------------------------------------------------
#This script will search the contents of tar gzip files
#in the specified directory for entries with matching
#specified search text.
#
#
# Dependencies: 
#   ../UsefulScripts/linux/lib/logging.sh
#
# version: 2023.3.16
#-----------------------------------------------------------
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
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

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
else
  #log "No Process Arguments Identified"
  printHelp
  exit 0
fi

#//check to make sure expected number of arguments were specified
log "Checking correct number of arguments..."
if (( argCount < 1 )); then
  echo "  ERROR: Missing arguments"
  exit 0
fi

#//get and check for valid line range
search="${ARG_VALUES[0]}"
log "Search: ${search}"

#//define default filter command arguments
filterCommand=("find" "-mindepth" "1" "-maxdepth" "${MAX_DEPTH}" "-type" "f" )

#//add file name filter option if provided
if (( argCount > 1 )); then
  filterCommand+=("-iname" "${ARG_VALUES[1]}")
else
  filterCommand+=("-iname" "*.tar.gz" "-o" "-iname" "*.tgz")
fi
log "File Filter: ${filterCommand[*]}"

#//obtain the current working directory
dir=$( pwd )
echo "DIR: ${dir}"
if [[ ! -d $dir ]]; then
  echo "Specified path is not a directory."
  exit 1
fi

#//list all file using the filter and loop through them
iter=0
for f in $(${filterCommand[@]})
do 
  #//keep track of iteration count and print status update indicator
  iter=$(( iter+1 ))
  if [[ $(( $iter%50 )) -eq 0 ]]; then
    echo -n "."
  fi 

  #//perform grep serch on the tar listing output and capture the located lines
  #result=$( zcat ${f} | strings | grep ${search} )
  result=$( zcat ${f} | grep -m 1 -a ${search} )

  #//check if grep found something (success)
  if [[ $? -eq 0 ]]; then
    echo ""
    echo "${f}"
    echo "${result}"
  fi

done

echo ""
echo "DONE"
