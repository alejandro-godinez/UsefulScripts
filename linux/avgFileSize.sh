#!/bin/bash
#---------------------------------------------------------------------------
# This script will get an average file size of all the file
# that meet the specified name filter.
#
# version: 2023.3.8
#
# Usage:
#   avgFileSize.sh <search> [dir]
#
#   search - The search pattern to use when listing files
#            NOTE: add quotes to the pattern
#   dir    - The directory in which to list files, current directory if not specified
#
# Example:  avgFileSize.sh "*.tar.gz"
#     - gets average file size for all '.tar.gz' files in the current directory
#----------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//toggle debug output
DEBUG=false

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

#//indexed array of arguments that are not options/flags
declare -a ARG_VALUES

function printHelp {
  echo "This script will get an average file size of all the file"
  echo "that meet the specified name filter."
  echo ""
  echo "Usage: "
  echo "  avgFileSize.sh <search> [dir] [-v] [-h]"
  echo ""
  echo "  search - The filter to use when listing files"
  echo "           NOTE: add quotes to the pattern"
  echo "  dir    - The directory in which to list files, current directory if not specified."
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo ""
  echo "Example:  avgFileSize.sh '*.tar.gz\'"
  echo "  - gets an average file size for all '.tar.gz' files in the current directory"
  echo ""
}

function log {
  if [ "$DEBUG" = true ]; then 
    echo "$1"
  fi
}

#//process the arguments for the script
function processArgs {
  #//check the command arguments
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
processArgs "$@"

#//print out the list of args that were not consumed by function (non-flag arguments)
argCount=0
if [[ -v ARG_VALUES ]]; then
  argCount=${#ARG_VALUES[@]}
  log "List Remaining Args: ${argCount}"
  for item in "${ARG_VALUES[@]}"; do echo "  ${item}"; done
else
  #log "No Process Arguments Identified"
  printHelp
  exit 0
fi

#//get the serach term from the first argument
search="${ARG_VALUES[0]}"
echo "Search: ${search}"

#//if the directory is not supplied default to current work directory
if (( argCount > 1 )); then
  dir="${ARG_VALUES[1]}"
else
  dir="$(pwd)/"
fi
echo "Dir: ${dir}"

#//check if the specified path is actually a directory
if [[ ! -d $dir ]]; then
  echo "Specified path is not a directory: $dir"
  exit 1
fi

#//find and keep sum of file count and size, print average in KiB
#find "${dir}" -iname "${search}" -type f -exec du -sb {} \; | awk ' { sum+=$1; ++n } END { if (n > 0) print "File Count: " print "Average (bytes): " sum/n/1024; else print "No Files Found" } '

#//find and keep sum of file count and space used, print total, count, and average
find "${dir}" -iname "${search}" -type f -exec du -sb {} \; | awk ' { sum+=$1; ++n; } END { if (n > 0) {printf("Total (KiB): %.4f \n", sum/1024); print "File Count: " n ;printf("Average (KiB): %.4f \n", sum/n/1024) }  else print "No Files Found" } '

exit 0
