#!/bin/bash
#-------------------------------------------------------------------------------
# Library implementation of common script argument processing functionality. The
# developer pre-defines the expected option codes along with indicator if the
# option will need to have a value specified. After calling the parsing function
# there are vaious getter functions to determine if option was specified.
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
#    addOption "-file" true
# 
#    # run processing of argument
#    parseArguments "$@"
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

# use of associative arrays requires bash 4 and greater
if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need at least bash-4.0 to run this script."
  exit 1
fi

# indexed array of arguments that were not defined
declare -a REM_ARGS

# associative array for option key and value
declare -A ARGS
# associative array for option key and boolean indicator if it needs a subsequence value
declare -A NEEDSVAL

# Check if the specified option key exists
# 
# @param option - the option name
# @return - 0 (zero) when true, 1 otherwise
function hasOption {
  local option=$1
  if [[ -v ARGS["$option"] ]]; then
    return 0
  fi
  return 1
}

# Add an option code/name that should be captured. If a value needs to be
# provided with the argument set value indicator to true.
# 
# @param option - the option name
# @param needsValue - true/false indicator that option will have argument (optional)
# @return - 0 (zero) when added, 1 otherwise
function addOption {
  local option=$1

  # check if the option name already exists in the array
  if hasOption "${option}" ; then
    return 1
  fi

  # add the option key to the array
  ARGS[$option]=false
  NEEDSVAL[$option]=false

  # check if needs value argument was provided
  if (( $# > 1 )) && [ "$2" = "true" ]; then
    NEEDSVAL[$option]=true
  fi
  
  return 0
}

# Check if the option needs to have a value provided following the code
# 
# @param option - the option name
# @return - 0 (zero) when true, 1 otherwise
function optionNeedsVal {
  local option=$1
  if [ "${NEEDSVAL[$option]}" = 'true' ]; then
    return 0
  fi
  return 1
}

# Sets the argument value for the specified option
# 
# @param option - the option name
# @param value - the argument value
function setArgument {
  local option=$1
  local value=$2
  ARGS[$option]=$value
}

# Get the argument value for an option name.
# 
# @param option - the option name
# @return - 0 (zero) with valid option, 1 otherwise.
# @output - the argument value
function getArgument {
  local option=$1
  if hasOption "${option}"; then
    echo "${ARGS[$option]}"
    return 0
  fi
  return 1
}

# Check if the specified option was parsed from the arguments.
# This checks if the value is not 'false'
# 
# @param option - the option name
# @return - 0 (zero) when true, 1 otherwise
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
# @param text - the text to check
# @return - 0 (zero) when true, 1 otherwise
function startsWithDash {
  if [[ $1 =~ ^- ]]; then
    return 0
  fi
  return 1
}

# Adds an entry to the argument remaining variable
# 
# @param arg - argument value
function addToREM {
  REM_ARGS+=("$1")
}

# Parsing and processing of the argument list
# 
# @param args - array of arguments, use "$@" from script call
function parseArguments {
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

        # if option needs value perform lookahead on next argument for the value value (option does not start with dash)
        if optionNeedsVal "$option" && (( $# > 0 )); then
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
  for index in "${!ARGS[@]}"; do echo "  $index -> ${ARGS[$index]} ${NEEDSVAL[$index]}"; done
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
# addOption "-file" true

#//process the arguments from the script
# parseArguments "$@"

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
