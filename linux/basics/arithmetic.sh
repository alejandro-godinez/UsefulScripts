#!/bin/bash

#-----------------------------------------------------------------------------
#  Bash Notes: 
#-----------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

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

#//modulo
result=$((result % 7))
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
