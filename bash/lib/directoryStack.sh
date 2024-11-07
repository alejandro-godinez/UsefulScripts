#!/bin/bash
#-------------------------------------------------------------------------------
# Library of various functions to facilitate the user of the bash directory
# stack.
# 
# 
# Import Sample Code:
# <pre>
# if [[ ! -f ~/lib/directoryStack.sh ]]; then
#   echo "ERROR: Missing directoryStack.sh library"
#   exit
# fi
# source ~/lib/directoryStack.sh
# </pre>
# 
# Usage:
# <pre>
# # gets index of folder using full path
# index=$(stackIndex /some/path/to/folderone)
# # gets index of older using some part of path
# index=$(stackIndex folderone)
# 
# # switches to path that is not on the stack by adding to stack (pushd)
# stackSwitch /some/path/to/foldertwo
# # switches to path that is on the stack
# 
# stackSwitch /some/path/to/foldertwo
# # switches to path that is on the stack using part of path
# stackSwitch folderone
# </pre>
#-------------------------------------------------------------------------------

# Gets the stack index of the specified directory if it exists, -1 otherweise
# 
# Notes: 
#  - dir path argument can be a partial path, such as the folder name
#  - will only return index of first match in stack
# 
# @param dir - the directory path to serach in the stack
# @output - index of dir in path, -1 when not found
# @return - 0 (zero) when found, 1 otherwise
function stackIndex {
  #//check for empty parameter
  if [[ -z "${1}" ]]; then
    echo "-1"
    return 1
  fi

  local dirPath="$1"

  # grep for line number with matching path, cut on ":" delimiter and get first field
  lineNo=$(dirs -v -l | grep -m 1 -in "${dirPath}" | cut -d: -f1)

  if [ -n "${lineNo}" ]; then
    echo $((lineNo - 1))
    return 0
  fi

  # dir not found
  echo "-1"
  return 1
}

# Switches to the specific directory path from the stack if a match exist, otherwise it
# push another entry onto the stack.
# Notes: 
#  - dir path argument can be a partial path, such as the folder name
#  - will switch to first match in stack
#  - it seems pushd will trim trailing directory slash, will affect matching if not careful
# 
# @param dir - the directory path to serach in the stack
# @return - 0 (zero) with swich, 1 otherwise
function stackSwitch {
  local dirPath="$1"

  # get the path index in the stack
  dirIndex=$(stackIndex "${dirPath}")

  # check if index was found
  if (( dirIndex > -1 )); then
    # switch to that index in the stack
    pushd +$dirIndex
    return 0
  fi

  # not in stack, check if path provided was full and exists
  if [ -d $dirPath ]; then 
    # add directory to stack
    pushd "$dirPath"
    return 0
  fi

  return 1
}



# -- TESTING --
# @break

# echo "- TESTING - "
# pushd ~/temp
# pushd "/c/Users/agodinez/OneDrive - Sompo"
# dirs -l -v
# stackIndex "~/OneDrive - Sompo"