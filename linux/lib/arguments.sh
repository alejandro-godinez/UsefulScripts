#!/bin/bash
#-------------------------------------------------------------------------------
# Library implementation of common script argument processing functionality.
# 
# Note: Any additional arguments that were not matched to expected option will
# stored and can be access via the 'REM_ARGS' variable
# 
# 
# Import Sample Code:
#   <pre>
#     if [[ ! -f ~/lib/arguments.sh ]]; then
#       echo "ERROR: Missing arguments.sh library"
#       exit
#     fi
#     source ~/lib/arguments.sh
#   </pre>
#  
# Usage:
#  <pre>
#    # define expected options
#    addOption "-v"
#    addOption "-file"
# 
#    # run processing of argument
#    processArgs "$@"
# 
#    # check and get argument value
#    if hasArgument "-file"; then
#      file=$(getArgument "-file")
#    fi
#  </pre>
# 
# Limitation Notes:
# - option codes should start with dash (ie. -v, -test, -filePath)
# - arguments without dash will be interpreted as value for the previous option
#-------------------------------------------------------------------------------

# indexed array of arguments that were not defined
declare -a REM_ARGS

# associative array for option key and value
declare -A ARGS

# Check if the specified option key exists
# 
# @param $1 - the option name
function hasOption {
  local option=$1
  if [[ -v ARGS["$option"] ]]; then
    return 0
  fi
  return 1
}

# Add an option code/name that should be captured
# 
# @param $1 - the option name
function addOption {
  local option=$1

  # check if the option name already exists in the array
  if hasOption "${option}" ; then
    return 1
  fi

  # add the option key to the array
  ARGS[$option]=false

  return 0
}

# Sets the argument value for the specified option
#
# @param $1 - the option name
# @param $2 - the argument value
function setArgument {
  local option=$1
  local value=$2
  ARGS[$option]=$value
}

# Get the argument value for an option name
# 
# @param $1 - the option name
function getArgument {
  local option=$1
  if hasOption "${option}"; then
    echo "${ARGS[$option]}"
    return 0
  fi
  return 1
}

# Check if the specified option was parsed from the arguments.
# This checks if the value is not empty
# 
# @param $1 - the option name
function hasArgument {
  local option=$1

  # check if option specified exists
  if ! hasOption "$option"; then
    return 1
  fi

  local val=$(getArgument "$option")
  if [[ "$val" = "false" ]]; then
    return 1
  fi

  # any other value means the option was encountered
  return 0
}

# Check if text starts with dash
# 
# @param $1 - the text to check
function startsWithDash {
  if [[ $1 =~ ^- ]]; then
    return 0
  fi
  return 1
}

# Adds an entry to the argument remaining variable
#
function addToREM {
  REM_ARGS+=("$1")
}

# Processing of the argument list
# 
# @param $1 - array of arguments, use "$@" from script call
function processArgs {
  # loop while there are still arguments
  while (( $# > 0 )); do
    arg=$1
    nextArg=''
    argFound=false

    # consume the current argument
    shift

    # check if option starts with dash otherwise push it to REM list
    if ! startsWithDash "$arg"; then
      addToREM "${arg}"
      continue
    fi

    # loop through each of the defined option keys
    for option in "${!ARGS[@]}"; do

      # test the option against
      if [ "${arg}" = "${option}" ]; then
        argFound=true

        # set option argument value to true when found
        setArgument "$option" true

        # perform lookahead on next argument for a potential option value (option does not start with dash)
        if (( $# > 0 )); then
          nextArg=$1
          if ! startsWithDash "$nextArg"; then
            setArgument "$option" "$nextArg"

            # consume the next argument so that it does not get processed
            shift
          fi
        fi

        break
      fi

    done

    # this argument option was not found in pre-defined list, add it to remaining arg variable
    if [ "$argFound" = false ]; then
      addToREM "${arg}"
    fi
  done
}

# Print to standard output the captured argument options and values
function printArgs {
  echo "Args:"
  for index in "${!ARGS[@]}"; do echo "  $index -> ${ARGS[$index]}"; done
}

# Prints to standard output all the remaining arguments that were not match to a defined option
function printRemArgs {
  echo "Remaining Args:"
  for index in "${!REM_ARGS[@]}"; do echo "  $index -> ${REM_ARGS[$index]}"; done
}

# - - - TESTING - - - 
#//add options
# addOption "-v"
# addOption "-h"

#//process the arguments from the script
# processArgs "$@"

#//debug print the option
# printArgs
# printRemArgs

# if hasOption "-v"; then
#   echo "hasOption()  Has Verbose Option"
# else
#   echo "hasOption()  NOT Has Verbose Option"
# fi

#//Check truthy option without complex value
# if hasArgument "-v"; then 
#   echo "hasArgument()  Has Verbose ARG"
# else 
#   echo "hasArgument()  NOT Has Verbose ARG"
# fi

#//test dash function 
# if startsWithDash "-s"; then
#   echo "Starts with dash"
# else
#   echo "NOT Starts with dash"
# fi
