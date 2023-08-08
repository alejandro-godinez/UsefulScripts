#!/bin/bash
#-------------------------------------------------------------------------------
# Library implementation with function to print a rotating character in place
# to demonstrate work being perform by long running script.
# 
# 
# Import Sample Code:
#   <pre>
#     if [[ ! -f ~/lib/spinner.sh ]]; then
#       echo "ERROR: Missing spinner.sh library"
#       exit
#     fi
#     source ~/lib/spinner.sh
#   </pre>
#  
# Usage:
#  <pre>
#    # spin the caracter one step
#    spinChar
#    # delete the spinner character at the end
#    spinDel
#  </pre>
#-------------------------------------------------------------------------------

SPINNER=("|" "/" "-" "\\")
SPIN_COUNT=4
SPIN_IDX=-1

# Set a different set of spinner characters
# 
# @param $@ - array of characters
function setSpinner {
  SPINNER=("$@")
  SPIN_COUNT=${#SPINNER[@]}
}

# Display the next step in the character spinner
function spinChar {
  # increment spin counter
  SPIN_IDX=$((++SPIN_IDX))

  # reset spinner back to zero
  if (( SPIN_IDX >= SPIN_COUNT )); then
    SPIN_IDX=0
  fi

  # print backspace to remove previous character and next spin character
  echo -en "\b${SPINNER[$SPIN_IDX]}"
}

# delete the spinner character
function spinDel {
  echo -en "\b \b"
}

# - - - TESTING - - - #
# newSpinner=('1' '2' '3' '4' '5' '6')
# setSpinner "${newSpinner[@]}"

# for i in {1..10}; do
#   spinChar
#   sleep .5
# done
# spinDel