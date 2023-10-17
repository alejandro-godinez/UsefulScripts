#!/bin/bash
#-------------------------------------------------------------------------------
# Library implementation with function to print a rotating set of characters 
# in place to demonstrate work being perform by long running script.
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
#    # delete the spinner character(s) (clear line)
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
  spinDel
  echo -en "${SPINNER[$SPIN_IDX]}"
  #echo -en "\b${SPINNER[$SPIN_IDX]}"
}

# delete the spinner character by clearing the currnet line content
function spinDel {
  # clear the current line
  echo -en "\033[2K"
  # move cursor to start of line
  echo -en "\r"
}

# - - - TESTING - - - #
#newSpinner=('10' '9' '8' '7' '6' '5') 
#newSpinner=('1/10' '2/10' '3/10' '4/10' '5/10' '6/10' '7/10' '8/10' '9/10' '10/10')
#setSpinner "${newSpinner[@]}"

# for i in {1..10}; do
#   spinChar
#   sleep .25
# done
# spinDel