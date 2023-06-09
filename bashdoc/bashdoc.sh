#!/bin/bash

#-------------------------------------------------------------------------------
# Parse documentation comments from bash script and generate markdown
# 
# Supported Keywords
#
# TODO: 
#   //list of most commonly used keywords
#   @author: Specifies the author of the class, method, or field.
#   @version: Specifies the version of the class, method, or field.
#   @param: Specifies the parameters of a method.
#   @return: Specifies the return value of a method.
#   @throws: Specifies the exceptions that may be thrown by a method.
#   @see: Specifies a link to another class, method, or field.
#   @since: Specifies the release of Java in which the class, method, or field was first introduced.
#   @deprecated: Specifies that the class, method, or field is deprecated and should not be used.
#-------------------------------------------------------------------------------

set -u # error on unset variable
set -e # exit on error

# echo print colors
NC='\033[0m' # No Color
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'

# import logging functionality
if [[ ! -f ~/lib/logging.sh ]]; then
  echo -e "${RED}ERROR: Missing logging.sh library${NC}"
  exit
fi
source ~/lib/logging.sh

# set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

# indexed array of arguments that are not options/flags
declare -a ARG_VALUES

# Line regular expressions
rgxComment="^([#][ ]).+$"
rgxFunction="^function ([a-zA-Z0-9_]+)[ ]?[{]?$"

# Print the usage information for this script to standard output.
function printHelp {
  echo "This script will parse the documentation comments from a bash script and generate"
  echo "markdown document."
  echo ""
  echo "Usage: "
  echo "  bashdoc.sh [OPTION] <file>"
  echo ""
  echo "  file - The input file to parse"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo ""
}

# Process and capture the common execution options from the arguments used when
# running the script. All other arguments specific to the script are retained
# in list variable.
#
# @param $1 - list of argument values provided when calling the script
function processArgs {
  # check the command arguments
  log "Arg Count: $#"
  while (( $# > 0 )); do
    arg=$1
    log "  Argument: ${arg}"
    
    # the arguments to the next item
    shift 
    
    # check for verbose
    if [ "${arg^^}" = "-V" ]; then
      DEBUG=true
      continue
    fi
    
    # check for help
    if [ "${arg^^}" = "-H" ]; then
      printHelp
      exit 0
    fi
    
    # keep arguments that are not options or values from the option
    log "    > Adding $arg to rem arg list"
    ARG_VALUES+=("$arg")
  done
}

function isComment {
  if [[ $1 =~ $rgxComment ]]; then
    return 0
  fi
  return 1
}

function isFunction {
  if [[ $1 =~ $rgxFunction ]]; then
    return 0
  fi
  return 1
}

#-------------------------------
# Main
#-------------------------------

#//enable logging library escapes
escapesOn

# process arguments
processArgs "$@"

# print out the list of args that were not consumed by function (non-flag arguments)
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


# get the input file from the first argument
inputFile="${ARG_VALUES[0]}"
logAll "Input File: ${inputFile}"

# check if the file exists
if [[ -e inputFile ]]; then
  echo "${RED}ERROR: input file not found${NC}"
  exit
fi

lineNo=0
lineNoPadded="000"

# Read the file line by line
while IFS= read -r line; do
  # count number of lines
  lineNo=$((++lineNo))
  
  #pad line number with spaces
  lineNoPadded=$(printf %4d $lineNo)

  # print line content with line number
  #log "[$lineNoPadded]: $line"

  # detect if this is a comment line
  if isComment "$line"; then
    logAll "[$lineNoPadded] - "${GRN}Comment:${NC}": $line"

  elif isFunction "$line"; then
    logAll "[$lineNoPadded] - "${BLU}Function:${NC}": $line"
  fi

done < $inputFile
