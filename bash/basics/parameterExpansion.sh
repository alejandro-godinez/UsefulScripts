#!/bin/bash

#--------------------------------------------------------------------------------
#  Bash Notes:
#    ${parameter:-word}  - substitution when unset
#    ${parameter:+word}  - substitution when set
#    ${parameter:=word}  - parameter replacement when unset
#    ${parameter:?word}  - substitution when unset to standard error (stops code)
#    ${paramater:offset}         - substring from offset
#    ${paramater:offset:length}  - substring from offset to count
# 
#    ${#parameter}  - length of characters
#--------------------------------------------------------------------------------

# value is substituted when unset
echo "-- substitution --"
unset val
echo ${val-hello}
val="world"
echo ${val-hello}
echo ""

# value is substituted when set
echo ${val+hello}
echo ""

# value is replaced when uset
echo "-- replacement --"
: ${val:=DEFAULT}
echo ${val}
unset val
: ${val:=DEFAULT}
echo ${val}
echo ""

# value is substitured when unset to standard error
# : ${val:?val is unset or null}
# echo $val
# unset val
# : ${val:?val is unset or null}
# echo ""

# substring expansions
echo "-- substring --"
val="0123456789"
echo "${val:5}"       # offset from start
echo "${val: -3}"     # offset from end
echo "${val:3:3}"     # offset with length
echo "${val: -3:2}"   # offset from end length towards right
echo "${val: -5: -1}" # offset from end length from end towards left

# array offset
echo "-- array offset --"
myArr=("zero" "one uno" "two" "three" "four" "five" "six")
echo "${myArr[@]:4}"
echo "${myArr[@]:1:3}"
echo "${myArr[@]: -3:2}"

echo "-- IFS Positional ('@' vs '*') --"
IFS="|"
echo "${myArr[@]}"
echo "${myArr[*]}"
unset IFS

# length of characters
echo "-- character length --"
val="Test"
echo "${val}:${#val}"

val="test testing tester"
echo "${val#*test}"
echo "${val##*test}"

# upper case (note: not posix )
echo "-- Uppercase --"
val="uppercase"
echo "${val}"
echo "  ${val^}"          #first character
echo "  ${val^^}"         #all characters
echo "  ${val^^[aeiou]}"  #all characters matching pattern
echo "-- Lowercase --"
val="LOWERCASE"
echo "${val}"
echo "  ${val,}"          #first character
echo "  ${val,,}"         #all characters
echo "  ${val,,[AEIOU]}"  #all characters matching pattern