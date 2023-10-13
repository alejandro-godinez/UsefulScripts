#!/bin/bash
#-------------------------------------------------------------------------------
#  Library of common re-usable prompt methods.
# 
# Import Sample Code:
#   <pre>
#     if [[ ! -f ~/lib/prompt.sh ]]; then
#       echo "ERROR: Missing prompt.sh library"
#       exit
#     fi
#     source ~/lib/prompt.sh
#   </pre>
#  
# Usage:
#  <pre>
#    # prompt for list of option
#    if promptSelection "one" "two" "three" ; then
#      selection=$REPLY
#    fi
#  </pre>
#-------------------------------------------------------------------------------

# Prompt for any user input without any validation. 
# User input is stored in the bash $REPLY variable
# 
# @param $1 - prompt text
# @return - exit value of zero indicates no error
function promptForInput {
  prompt=$1
  read -p "$prompt"
}

# Prompt user for a yes or no response
# 
# @param $1 - prompt text
# @return - 0 (zero) when yes, 1 otherwise
function promptYesNo {
  prompt=$1

  read -p "$prompt"

  # upercase response to avoid performing multiple checks
  response="${REPLY^^}"

  # check if user reply "yes"
  if [[ "$response" == "Y" ]] || [[ "$response" == "YES" ]]; then
    return 0
  fi
  return 1
}

# Prompt user for an integer number value
# User input is stored in the bash $REPLY variable
# 
# @param $1 - prompt text
# @return - 0 (zero) when input is valid integer, 1 otherwise
function promptForInteger {
  prompt=$1

  read -p "$prompt "

  # check if user reply is numeric
  if [[ $REPLY =~ ^[0-9]+$ ]]; then
    return 0
  fi
  return 1
}

# Prompt user to select from list
# User selection value is stored in the bash $REPLY variable
# 
# @param $1 - the prompt text
# @param $2..n - array of options
# @return - 0 (zero) when selection from list is valid, 1 otherwise
function promptSelection {
  # capture prompt from first argument and consume
  local prompt=$1
  shift

  # capture remaining arguments as options into array
  local options=("$@")
  local optionCount=${#options[@]}
  local optionNo=0

  #echo "Select Option from List:"
  for option in "${options[@]}" ; do
    # increment option counter
    optionNo=$((++optionNo))
    echo "  ${optionNo}. ${option}"
  done

  if promptForInteger "$prompt" ; then
    # decrement input option number to zero-index
    optionNo=$(($REPLY-1))
    #echo "Option index: $optionNo"

    # check if number entered is outside option range
    if (( $REPLY < 0 )) || (( $REPLY > $optionCount )); then
      return 1
    fi

    REPLY=${options[${optionNo}]}
    return 0
  fi
  return 1
}

# - - - TESTING - - - 

#//prompt for any type of input
#promptForInput "What is your name?"
#echo "Response: $REPLY"

#//prompt for YES/NO
# if promptYesNo "Are you testing yes/no prmopt?"; then
#   echo "Response: Yes"
# else
#   echo "Response: No"
# fi
# echo "Reply: $REPLY"

#//prompt for integer number
# if promptForInteger "Is an even number?"; then
#   echo "Response: $REPLY"
#   if [ $(( $REPLY % 2 )) -eq 0 ]; then
#     echo "Number is EVEN"
#   else
#     echo "Number is ODD"
#   fi
# else
#   echo "Error: Response was not an integer"
# fi

#//prompt selection from array 
# options=("one" "two" "three")
# if promptSelection "Enter number of selection:" "${options[@]}"; then
# #if promptSelection "Enter number of selection:" "one" "two" "three"; then
#   echo "Selected: $REPLY"
# else
#   echo "Error: no selection"
# fi