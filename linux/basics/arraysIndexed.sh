#!/bin/bash

#--------------------------------------------------------------------------------
#  Bash Notes:
#    [@]   - expands values to separate words
#    ${!   - the ! here expands the indices (keys) instead of the values
#    local - can be used instead of declare when in a function
#--------------------------------------------------------------------------------


#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

# Delete (unset) an item index position from an array. This method will
# collapse all the items ahead of delete position and unset the last position.
# This avoids breaking the index sequence.
# 
# <pre>
# Example: arrayDelete 3 arrayName
# </pre>
# 
# @param $1 - the index position to delete from the aray
# @param $2 - the nameref of the array
function arrayDelete {
  local delIndex=$1
  shift

  #use nameref to array for indirection
  local -n arr=$1

  for index in "${!arr[@]}"; do 
  if (( index > delIndex )); then
      nextIndex=$((index - 1))
      arr[nextIndex]="${arr[index]}"
  fi
  done
  unset 'myArr[-1]'
}

#//standard array
echo "Declare Index Array"
#//explicity index array using 'declare -a'
declare -a myArr=("one" "two" "three") 

#//non-explict index array
#myArr=("one" "two" "three") 

for item in "${myArr[@]}"; do echo "  ${item}"; done
echo ""

#//assign values to index position 
echo "Assign 'dos' to index [1]"
myArr[1]="dos"
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
echo ""

#//add value to position that doesn't exist, NOTE: skips index [3]
echo "Assign 'five' to index [4]"
myArr[4]="five"
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
echo "  Array Value Count: ${#myArr[@]}"
echo ""


#//add value to position that hasn't been assigned, NOTE: inserts position
echo "Assign 'four' to index [3]"
myArr[3]="four"
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
echo ""

#//append single item with shorthand
echo "Add single entry, shorthand (SINGLE)"
myArr+=("SINGLE")
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
echo ""

#//append multiple to existing array
echo "Add multiple entries in one go (A, B, C)"
myArr=("${myArr[@]}" "A" "B" "C")
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
echo ""

#//Get the count of entries for an array
echo "Array Value Count: ${#myArr[@]}"
echo ""

#//Unset array positions
echo "Unset array position (looses index sequence)"
unset 'myArr[1]'
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done

echo "Remove array item function"
myArr[1]="two" #//restore the previously removed item
echo "  Removing ${myArr[0]}"
arrayDelete 0 myArr
echo "  Removing ${myArr[3]}"
arrayDelete 3 myArr
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
