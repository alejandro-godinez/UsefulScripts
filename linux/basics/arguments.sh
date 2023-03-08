#!/bin/bash

#-----------------------------------------------------------------------------
#  Bash Notes: 
#    function   - keyword optional for readability in bash, for POSIX use
#                 use parenthesis syntax instead "myfunc(){ }"
#    shift      - drops the top most entry in the argument list
#    ${var^^}   - get the capitalized value
#-----------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//numeric regex
RGX_NUM='^[0-9]+$'

#//toggle debug output
DEBUG=true

#//max number from argument
MAX_NUMBER=0

#//indexed array of arguments that are not options/flags
declare -a ARG_VALUES

#//function that will echo only if verbose option was provided
function log {
  if [ "$DEBUG" = true ]; then 
    echo "$1"
  fi
}

#//function to process the arguments
function processArgs {
  log "  Arg Count: $#"
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
      
    #//check for depth
    if [ "${arg^^}" = "-D" ]; then
    
      #//check if there are still more arguments where the number could be provided
      if (( $# > 0 )); then
        #//check the depth number from next argument
        numValue=$1
        log "    Number Value: $numValue"
        
        if [[ $numValue =~ $RGX_NUM ]]; then
          MAX_NUMBER=$numValue
          log "    Max Number Set: $MAX_NUMBER"
          
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

log "Calling process args function"
processArgs "$@"

#//print out the list of args that were not consumed by function (non-flag arguments)
if [[ -v ARG_VALUES ]]; then
  log "List Remaining Args: ${#ARG_VALUES[@]}"
  for item in "${ARG_VALUES[@]}"; do echo "  ${item}"; done
else
  log "NO Remaining Args"
fi
