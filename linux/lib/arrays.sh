#!/bin/bash
#-------------------------------------------------------------------------------
#  Library of common functions for manipulating arrays
# 
# Import Sample Code:
#   <pre>
#     if [[ ! -f ~/lib/arrays.sh ]]; then
#       echo "ERROR: Missing arrays.sh library"
#       exit
#     fi
#     source ~/lib/arrays.sh
#   </pre>
#-------------------------------------------------------------------------------

# Delete (unset) an item index position from an array. This method will
# collapse all the items ahead of delete position and unset the last position.
# This avoids breaking the index sequence.<br>
# <br>
# <u>Examples:</u><br>
# arrayDelete 3 arrayName
# 
# @param $1 - the index position to delete from the aray
# @param $2 - the array reference to the array
function arrayDelete {
  local deleteIdx=$1
  shift

  #use nameref to array for indirection
  local -n arr=$1

  for index in "${!arr[@]}"; do 
  if (( index > deleteIdx )); then
      prevIndex=$((index - 1))
      arr[prevIndex]="${arr[index]}"
  fi
  done
  unset 'myArr[-1]'
}

# Gets the index number of the last position of the array.
# Note: index numbers may not be sequential if uset was used<br>
# <br>
# <u>Examples:</u><br>
# lastIndex=$( getLastIndex arrayName )
# 
# @param $1 - the array reference to the array
# @return - the last index number
function getLastIndex {
  #use nameref to array for indirection
  local -n arr=$1
  local indexes=( "${!arr[@]}" )
  echo ${indexes[-1]}
}

# Sorts the array in acending order<br>
# <br>
# <u>Examples:</u><br>
# sortArrayAsc arrayName )
# 
# @param $1 - the array reference to the array
function sortArrayAsc {
  #use nameref to array for indirection
  local -n arr=$1
  IFS=$'\n'
  arr=($(sort <<< "${arr[*]}")); 
  unset IFS
}

# Sorts the array in descending order<br>
# <br>
# <u>Examples:</u><br>
# sortArrayDec arrayName
# 
# @param $1 - the array reference to the array
function sortArrayDec {
  #use nameref to array for indirection
  local -n arr=$1
  IFS=$'\n'
  arr=($(sort -r <<< "${arr[*]}")); 
  unset IFS
}

# - - - TESTING - - - 
#declare -a myArr=("one" "two" "three" "four" "five" "six")
#for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
#sortArrayAsc myArr
#sortArrayDec myArr
#for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
#echo "${myArr[@]}"

#for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done

# echo "Remove array item function"
# echo "  Removing ${myArr[0]}"
# arrayDelete 0 myArr
# echo "  Removing ${myArr[3]}"
# arrayDelete 3 myArr
# for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done

# index=$(getLastIndex myArr)
# echo "Last Index: $index"