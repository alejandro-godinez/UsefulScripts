#!/bin/bash
#---------------------------------------------------------------------------
# This script will get an average file size of all the file
# that meet the specified name filter.
# 
# 
# Dependencies:  
#   ../UsefulScripts/linux/lib/logging.sh  
#   ../UsefulScripts/linux/lib/arguments.sh
# 
# version: 2023.7.25
#----------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

# use of associative arrays requires bash 4 and greater
if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need at least bash-4.0 to run this script."
  exit 1
fi

#//echo print colors
NC='\033[0m' # No Color
RED='\033[0;31m'

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

# Print the usage information for this script to standard output.
function printHelp {
  echo "This script will get an average file size of all the file"
  echo "that meet the specified name filter."
  echo ""
  echo "Usage: "
  echo "  avgFileSize.sh [OPTION] <search> [dir]"
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

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  
  # initialize expected options
  addOption "-v"
  addOption "-h"

  # perform parsing of options
  parseArguments "$@"

  #printArgs
  #printRemArgs
    
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

#//get the search term from the first argument
search="${REM_ARGS[0]}"
logAll "Search: ${search}"

#//if the directory is not supplied default to current work directory
if (( argCount > 1 )); then
  dir="${REM_ARGS[1]}"
else
  dir="$(pwd)/"
fi
logAll "Dir: ${dir}"

#//check if the specified path is actually a directory
if [[ ! -d $dir ]]; then
  logAll "Specified path is not a directory: $dir"
  exit 1
fi

#//find and keep sum of file count and size, print average in KiB
#find "${dir}" -iname "${search}" -type f -exec du -sb {} \; | awk ' { sum+=$1; ++n } END { if (n > 0) print "File Count: " print "Average (bytes): " sum/n/1024; else print "No Files Found" } '

#//find and keep sum of file count and space used, print total, count, and average
find "${dir}" -iname "${search}" -type f -exec du -sb {} \; | awk ' { sum+=$1; ++n; } END { if (n > 0) {printf("Total (KiB): %.4f \n", sum/1024); print "File Count: " n ;printf("Average (KiB): %.4f \n", sum/n/1024) }  else print "No Files Found" } '

exit 0
