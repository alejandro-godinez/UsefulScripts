#!/bin/bash

#-----------------------------------------------------------------------------
#  Bash Notes: 
#    local - declare variables accessible locally in scope.
#            NOTE:  local variables are accessible to child method calls
#-----------------------------------------------------------------------------

globalArr=(one two)

function functionOne {
  local localArr=("three" "four")
  echo "In functionOne:"
  echo "global_ary: ${globalArr[@]}"
  echo "local_ary: ${localArr[@]}"
  echo

  functionTwo
}

# local variables from calling functions are accessible
function functionTwo {
  echo "In functionTwo:"
  echo "global_ary: ${globalArr[@]}"
  echo "local_ary: ${localArr[@]}"
  echo
}

echo "In Main:"
echo "global_ary: ${globalArr[@]}"
echo "local_ary: ${localArr[@]}"
echo

functionOne

echo "In Main:"
echo "global_ary: ${globalArr[@]}"
echo "local_ary: ${localArr[@]}"
echo