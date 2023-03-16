#!/bin/bash

#-----------------------------------------------------------
#This script will search the contents of any '.tar.gz' file
#in the specified directory for entries with matching
#specified search text.
#
# Dependencies: 
#   ../UsefulScripts/linux/lib/logging.sh
#
# version: 2023.3.16
#-----------------------------------------------------------

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
  echo "  findFileInTarGzip.sh [options] <search> [tgzFilter]"
  echo ""
  echo "  search - the text in the file's name to search for"
  echo "  tgzFilter - additional limit to the list of tgz files that will be searched."
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo ""
  echo "Example: findFileInTarGzip.sh test.txt 2018"
  echo "  - this will list '*2018*.tar.gz' files and search entries containing 'test.txt'"
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
echo "Search: ${search}"


#//if filter is not supplied default to all '.tar.gz' files
if (( argCount > 1 )); then
  tgzFilter="*${ARG_VALUES[1]}*.tar.gz"
else
  tgzFilter="*.tar.gz"
fi
log "FILTER: ${tgzFilter}"

#//obtain the current working directory
dir=$( pwd )
echo "DIR: ${dir}"
if [[ ! -d $dir ]]; then
  echo "  ERROR: Specified path is not a directory."
  exit 1
fi

#//list all file using the filter and loop through them
iter=0
echo "Depth Search: $MAX_DEPTH"
for f in $( find ${dir} -mindepth 1 -maxdepth $MAX_DEPTH -name "${tgzFilter}" -type f )
do 
  #//keep track of iteration count and print status update indicator
  iter=$(( iter+1 ))
  if [[ $(( $iter%50 )) -eq 0 ]]; then
    echo -n "."
  fi 

  #//perform grep serch on the tar listing output and capture the located lines
  result=$( tar -tvf ${f} | grep ${search} )

  #//check if grep found something (success)
  if [[ $? -eq 0 ]]; then
    echo ""
    echo "${f}"
    echo "${result}"
  fi

done

echo ""
echo "DONE"
