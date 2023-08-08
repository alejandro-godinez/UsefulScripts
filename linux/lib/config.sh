#!/bin/bash
#-------------------------------------------------------------------------------
# Library implementation with functions to read from a configuration file
# with simple name value pair (i.e. name=value). The value is acquired after
# the first instance of the equal sign, therefore equals character is valid in
# the value.
# 
# TODO:
# - Add write functionality
# - Get a list of available property names
# 
# Import Sample Code:
#   <pre>
#     if [[ ! -f ~/lib/config.sh ]]; then
#       echo "ERROR: Missing config.sh library"
#       exit
#     fi
#     source ~/lib/config.sh
#   </pre>
#  
# Usage:
#  <pre>
#    # check if property exists
#    if hasProperty "name" "file.config"; then
#      # get the value
#      value=$(getProperty "name" "file.config")
#    fi
#  </pre>
#-------------------------------------------------------------------------------

# Check if the config file has property name
# 
# @param $1 - The config file
# @param $2 - the property name
function hasProperty {
  local configFile="$1"
  local propName="$2"

  # check if config file specified exists
  #echo "Config File: $configFile"
  if [ ! -f $configFile ]; then
    #echo "Config File Not Found"
    return 1
  fi

  # use grep to get a count of matches for ('propName=')
  matchCount=$(grep -cE "^(\s*)${propName}=" "${configFile}")
  if (( matchCount > 0 )); then
    return 0
  fi
  
  # property not found
  return 1
}

# Get the property value
# 
# @param $1 - The config file
# @param $2 - the property name
function getProperty {
  local configFile="$1"
  local propName="$2"

  # check if config file specified exists
  if [ ! -f $configFile ]; then
    return 1
  fi

  # perform a grep to capture the line with the property 
  propLine=$(grep -E "^(\s*)${propName}=" "${configFile}")
  #echo "${propLine}"

  # perform a match to extract the value
  if [[ $propLine =~ ${propName}=(.+) ]]; then
    echo "${BASH_REMATCH[1]}"
    return
  fi

  # property name was not matched
  echo ""
}

# -- TESTING --
# configFile="./test/test.config"
# declare -a props=("name" "country" "lastupdate" "somekey") 
# for property in "${props[@]}"; do
#   if hasProperty "$configFile" "$property"; then
#     echo -n "${property} - "
#     value=$(getProperty "$configFile" "$property")
#     echo "$value"
#   else
#     echo "${property} - [Not Found]"
#   fi
# done