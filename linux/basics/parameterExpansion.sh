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
unset val
echo ${val-hello}
val="world"
echo ${val-hello}
echo ""

# value is substituted when set
echo ${val+hello}
echo ""

# value is replaced when uset
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
val="0123456789"
echo ${val:5}       # offset from start
echo ${val: -3}     # offset from end
echo ${val:3:3}     # offset with length
echo ${val: -3:2}   # offset from end length towards right
echo ${val: -5: -1} # offset from end length from end towards left

# array offset
myArr=("zero" "one" "two" "three" "four" "five" "six")
echo ${myArr[@]:4}
echo ${myArr[@]:1:3}

# length of characters
val="Test"
echo "${val}:${#val}"

val="test testing tester"
echo "${val#*test}"
echo "${val##*test}"