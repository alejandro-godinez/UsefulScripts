#!/bin/bash

#-----------------------------------------------------------------------------
#  Bash Notes: 
#    (( ))   - arithmetic expresions
#     [ ]    - POSIX test commands
#    [[ ]]   - newer test commands with extended funcionality available in bash
#    -z      - checks for empty string
#    -n      - checks for non-empty string
#-----------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//numeric regex
RGX_NUM='^[0-9]+$'


myNum=3
myText="test"
emptyString=""
longString="One Two Three"

echo "Numeric Comparisons"
#//numeric comparison
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
