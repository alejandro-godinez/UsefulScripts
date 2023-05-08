#!/bin/bash
#-----------------------------------------------------------------------
# This script will change the value of a standard name=value pair file
# such as ini or config files. 
#
#   Note: this is a simple implementation where properties need to be
#         at the start of the line
#
#
# Dependencies: 
#   ../UsefulScripts/linux/lib/logging.sh
#
# TODO:
#   - improve to support indented properties
#
# version: 2023.3.16
#-----------------------------------------------------------------------

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
if (( argCount < 3 )); then
  logAll "  ERROR: Missing arguments"
  exit 0
fi

#//get and check if specified file does not exist
log "Checking if the file exists..."
file="${ARG_VALUES[0]}"
if [[ ! -f  $file ]]; then
  logAll "  ERROR: File specified was not found"
  exit 1
fi
logAll "FILE: ${file}"

#//get and check if the option name was specified
log "Checking the option name..."
optionName="${ARG_VALUES[1]}"
if [[ -z "${optionName// }" ]]; then
  logAll "Option name no specified."
  exit 1
fi
logAll "Option Name: ${optionName}"

#//get and check if the option value was specified
log "Checking the option value..."
optionValue="${ARG_VALUES[2]}"
if [[ -z "${optionValue// }" ]]; then
  logAll "Option value not specified."
  exit 1
fi
logAll "Option Value: ${optionValue}"

#//check to see if the specified option name exists
log "Check if the option name exists..."
optionExists=$(grep -c "^${optionName}=" "${file}")
log "Option Exists: ${optionExists}"
if (( optionExists == 0 )); then
  logAll "  ERROR: The specified option name was not found."
  exit 1
fi

#//check to see if the specified option already is already set to the same value
log "Check if the option already has the same value..."
alreadySet=$(grep -c "^${optionName}=${optionValue}$" "${file}")
log "Already Exists: ${alreadySet}"
if (( alreadySet == 1 )); then
  logAll "The option already has the value specified."
  exit 0
else
  logAll "Updating the option..."
  sed -i "s/^${optionName}=.*/${optionName}=${optionValue}/" "${file}"
fi

#//check if the value was changed
logAll "Checking if value was changed..."
alreadySet=$(grep -c "^${optionName}=${optionValue}" "${file}")
if (( alreadySet == 0 )); then
  alreadyset="No"
else
  alreadySet="Yes"
fi
logAll "Changed?: $alreadySet"

logAll "Done"
