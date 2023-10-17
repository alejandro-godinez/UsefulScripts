#!/bin/bash

#-----------------------------------------------------------------------------
#  Bash Notes:
#    division - bash natively does not perform decimal operations
#-----------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

# Perform native bash division
# Note: bash only works with integers, fake it using fixed point arithmetic
# 
# @param dividend - number being divided
# @param divisor - number to divide by
# @param precision - decimal precision (scale factor), defaults to 2
# @output - result of division, written to standard output
function div {
  # default precision scale to 2 decimal places
  local precision=2
  local scale=100

  # check if scale parameter was specified
  if (( $# > 2 )) && [[ ! -z ${3} ]] && (( $3 >= 1)); then
    precision=$3
    scale=$((10**precision))
  fi

  # check for zero, no need to perform division just pad zeros
  if (( $1 == 0 )); then
    echo $(printf "%.${precision}f" "0")
    return
  fi
  
  # multiple by scale and perform division
  local result=$(($scale * $1 / $2))

  # insert decimal into result
  result="${result:0:-$precision}.${result: -$precision}"
  echo "${result}"
}

result=50
echo "Initial Value: $result"

#//addition
result=$((result + 3))
echo "Add 3:    $result"

#//subtraction
result=$((result - 7))
echo "Sub 7:    $result"

#//post increment
result=$((result++))
echo "Post-Inc: $result"

#//pre increment
result=$((++result))
echo "Pre-Inc:  $result"

#//post decrement
result=$((result--))
echo "Post-Dec: $result"

#//pre decrement
result=$((--result))
echo "Pre-Dec:  $result"

#//multiply
result=$((result * 10))
echo "Mul 2:    $result"

#//divide
result=$((result / 2))
echo "Div 2:    $result"

#//decimal division, bash does not support natively
result=$(div 22 4 3)
echo "Div Dec.: $result"

#//decimal division, zero needs special handling in div function
result=$(div 0 60)
echo "Div Zero.: $result"

#//decimal division using awk
result=$(awk 'BEGIN {printf "%.3f", 22/8}')
echo "Div awk: $result"

#//modulo
result=$((30 % 7))
echo "Mod 7:    $result"

#//exponent
result=$((result ** 0))
echo "Exp 0:    $result"

#//left biwise shift  (0001 << 2 = 0100)
result=$((result << 2))
echo "LShift 2: $result"

#//right biwise shift (0100 >> 1 = 0010)
result=$((result >> 1))
echo "RShift 1: $result"
