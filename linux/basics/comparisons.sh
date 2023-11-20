#!/bin/bash

#-----------------------------------------------------------------------------
#  Bash Notes: 
#    (( ))   - arithmetic expresions
#     [ ]    - POSIX test commands
#    [[ ]]   - newer test commands with extended funcionality available in bash
#    -z      - checks for empty string
#    -n      - checks for non-empty string
#    -v      - checks for allocated variable/array
#-----------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

#//numeric regex
RGX_NUM='^[0-9]+$'
RGX_UPPERCASE='^[A-Z]+$'

myNum=3
myText="test"
emptyString=""
longString="One Two Three"
declare -a unboundArray
declare -a boundArray=("temp")

# assign builtin true/false
isTrue=true
isFalse=false

#//boolean comparison
echo "Boolean Comparisons"
if [ "$isTrue" = true ]; then
  echo "True boolean"
fi
if [ "$isFalse" = false ]; then
  echo "False Boolean"
fi

#//numeric comparison
echo "Numeric Comparisons"
if (( myNum == 3 )); then 
  echo "  Equals"
fi

#//greater than
if (( myNum > 1 )); then
  echo "  Greater Than"
fi

#//For POSIX shells
if [ "$myNum" -lt "9" ]; then 
  echo "  Less Than"
fi

echo "String Comparisons"

#//check for empty string
if [[ -z "${emptyString}" ]]; then
  echo "  Empty String"
fi

#//check for non-empty string
if [[ -n "${myText}" ]]; then
  echo "  Non-Empty String"
fi

#//check for equality using test command [ ]
if [ "$myText" = "test" ]; then
  echo "  Test Command [ ] Equality"
fi

#//check for equality using patter command [[ ]]
if [[ "$myText" == "test" ]]; then
  echo "  Pattern Command [[ ]] Equality"
fi

if [[ "$myText" != "TEST" ]]; then
  echo "  Pattern Command [[ ]] Inequality"
fi

echo "Substring Contains"

#//check for substring
if [[ "$longString" == *"Two"* ]]; then
  echo "  Substring Is There"
fi

echo "Regular Expression"
if [[ "$myNum" =~ $RGX_NUM ]]; then
  echo "  Regex Match"
fi
if [[ ! "$myText" =~ $RGX_NUM ]]; then
  echo "  Regex Not Match"
fi
if [[ "ABCDEF" =~ $RGX_UPPERCASE ]]; then
  echo "  Upper Case Matched"
else
  echo "  ERROR: Unexpected Upper Case NO Match"
fi
if [[ ! "Abc" =~ $RGX_UPPERCASE ]]; then
  echo "  Upper Case Not Matched"
else
  echo "  ERROR: Unexpected Upper Case Match"
fi

echo "Array Initialized"
#//check for 
if [[ -v boundArray ]]; then
  echo "  Bound Array"
fi

#//check for unbound array
if [[ ! -v unboundArray ]]; then
  echo "  Unbound Array"
fi
