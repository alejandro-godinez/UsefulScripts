#!/bin/bash
#-----------------------------------------------------------------------
# This script will change the value of a standard name=value pair file
# such as ini or config files.  
# 
#   Note: This is a simple implementation sections are not yet supported.  
#         Duplicate keys under different sections will all be changed.
# 
# 
# Dependencies:  
#   ../UsefulScripts/linux/lib/logging.sh  
# 
# TODO:  
#   - improve support for targetting values under sections  
# 
# version: 2023.5.25
#-----------------------------------------------------------------------

set -u #//error on unset variable

#//echo print colors
NC='\033[0m'       # No Color
GRN='\033[0;32m'
YEL='\033[1;33m'
RED='\033[0;31m'
U_CYN='\033[4;36m'       # Cyan

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
  echo "This script will change the value of a standard 'name=value' pair"
  echo "such as ini or config files."
  echo ""
  echo "Usage: "
  echo "  changeOptionValue.sh [OPTIONS] <file> <optionName> <optionValue>"
  echo ""
  echo "  file        - the file which contains name=value data"
  echo "  optionName  - the name of the option to change"
  echo "  optionValue - the new value to update into the option"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
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

#//enable logging library escapes
escapesOn

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
if (( argCount < 3 )); then
  logAll "  ${RED}ERROR: Missing arguments${NC}"
  logAll ""
  printHelp
  exit 0
fi

#//get and check if specified file does not exist
log "Checking if the file exists..."
file="${REM_ARGS[0]}"
if [[ ! -f  $file ]]; then
  logAll "  ${YEL}ERROR: File specified was not found${NC}"
  logAll "  ${YEL}FILE: ${file}${NC}"
  exit 1
fi
logAll "${U_CYN}FILE:${NC} ${file}"

#//get and check if the option name was specified
log "Checking the option name..."
optionName="${REM_ARGS[1]}"
if [[ -z "${optionName// }" ]]; then
  logAll "Option name no specified."
  exit 1
fi
logAll "${U_CYN}Option Name:${NC} ${optionName}"

#//get and check if the option value was specified
log "Checking the option value..."
optionValue="${REM_ARGS[2]}"
if [[ -z "${optionValue// }" ]]; then
  logAll "Option value not specified."
  exit 1
fi
logAll "${U_CYN}Option Value:${NC} ${optionValue}"

#//check to see if the specified option name exists
log "Check if the option name exists..."
optionExists=$(grep -cE "^(\s*)${optionName}=" "${file}")
log "Option Exists: ${optionExists}"
if (( optionExists == 0 )); then
  logAll "  ${YEL}ERROR: The specified option name was not found.${NC}"
  exit 1
fi

#//check to see if the specified option already is already set to the same value
log "Check if the option already has the same value..."
alreadySet=$(grep -cE "^(\s*)${optionName}=${optionValue}$" "${file}")
log "Already Set: ${alreadySet}"
if (( alreadySet == 1 )); then
  logAll "The option already has the value specified."
  exit 0
else
  logAll "Updating the option..."
  sed -E -i "s/^(\s*)${optionName}=.*/\1${optionName}=${optionValue}/" "${file}"
fi

#//check if the value was changed
logAll "Checking if value was changed..."
alreadySet=$(grep -cE "^(\s*)${optionName}=${optionValue}" "${file}")
if (( alreadySet == 0 )); then
  alreadyset="${RED}NO${NC}"
else
  alreadySet="${GRN}YES${NC}"
fi
logAll "Changed?: $alreadySet"
