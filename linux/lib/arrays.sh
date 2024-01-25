#!/bin/bash
#-------------------------------------------------------------------------------
# Library of common functions for manipulating arrays or maps (associative).
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

# Check if the array/map has an index or key position
# <u>Examples:</u><br>
# arrayHasKey myArray 3
# arrayHasKey myMap "thekey"
#
# @param arr - the reference to the array or map (named reference)
# @param arrKey - the index or key to check
function arrayHasKey {
  #use nameref to array for indirection
  local -n arr=$1
  local arrKey=$2

  #if [ "${arr[key]+abc}" ]; then
  if [[ -v arr[$arrKey] ]]; then
    return 0
  fi
  return 1
}

# Delete (unset) an item index position from an array. This method will
# collapse all the items ahead of delete position and unset the last position.
# This avoids breaking the index sequence when using unset alone.<br>
# <br>
# <u>Examples:</u><br>
# arrayDeleteIndex myArray 3
# 
# @param arr - the reference to the array (named reference)
# @param deleteIdx - the index position to delete from the aray
# 
function arrayDeleteIndex {
  #use nameref to array for indirection
  local -n arr=$1
  local deleteIdx=$2

  # collapse index positions
  for index in "${!arr[@]}"; do 
    if (( index > deleteIdx )); then
        prevIndex=$((index - 1))
        arr[prevIndex]="${arr[index]}"
    fi
  done

  # unset the last position
  unset myArr[-1]
}

# Delete (unset) a map entry by the key.
# <br>
# <u>Examples:</u><br>
# mapDeleteKey myMap 'thekey'
# 
# @param map - the reference to the map (named reference)
function mapDeleteKey {
  #use nameref to array for indirection
  local -n map=$1
  local mapKey=$2

  unset map[$mapKey]
}

# Gets the index number of the last position of the array.
# Note: index numbers may not be sequential if uset was used<br>
# <br>
# <u>Examples:</u><br>
# lastIndex=$( arrayLastIndex arrayName )
# 
# @param arr - the name reference to the array
# @output - the last index number it written to standard output
function arrayLastIndex {
  #use nameref to array for indirection
  local -n arr=$1
  local indexes=( "${!arr[@]}" )
  echo ${indexes[-1]}
}

# Sorts the array in acending order<br>
# <br>
# <u>Examples:</u><br>
# arraySortAsc arrayName )
# 
# @param arr - the array reference to the array
function arraySortAsc {
  #use nameref to array for indirection
  local -n arr=$1
  IFS=$'\n'
  arr=($(sort <<< "${arr[*]}")); 
  unset IFS
}

# Sorts the array in descending order<br>
# <br>
# <u>Examples:</u><br>
# arraySortDesc arrayName
# 
# @param arr - the array reference to the array
function arraySortDesc {
  #use nameref to array for indirection
  local -n arr=$1
  IFS=$'\n'
  arr=($(sort -r <<< "${arr[*]}")); 
  unset IFS
}

# Print the contents of the array to standard output
# Prints out entries in the format "key:value"
# 
# <u>Examples:</u><br>
# arrayPrint arrayName
#
# @param arr - the reference to the array or map (named reference)
function arrayPrint {
  local -n arr=$1
  for index in "${!arr[@]}"; do echo "  ${index}:${arr[$index]}"; done
}

# - - - TESTING - - - 
# declare -a myArr=("zero" "one" "two" "three" "four" "five" "six")
# declare -A myMap=(["one"]="uno" ["two"]="dos" ["three"]="tres")

#//test key check on array
#key=4
# echo -n "Checking for Array Index [$key]"
# if arrayHasKey myArr $key; then echo "  Key Found"; else echo "  Key NOT found"; fi
# printArray myArr


#//test key check on map
# key=one
# echo -n "Checking for Map key [$key]"
# if arrayHasKey myMap $key; then echo "  Key Found"; else echo "  Key NOT found"; fi
# printArray myMap


#//test array delete functions
# index=4
# echo "Array Before:"
# printArray myArr
# echo "Removing Index - [$index]"
# arrayDeleteIndex myArr $index
# #unset myArr[4] # unset by itself will break the index sequence
# echo "Array After:"
# printArray myArr
# echo

#//test map delete functions
# key='two'
# echo "Map Before:"
# printArray myMap
# echo "Removing Key - ${myMap[$key]}"
# #unset myMap[$key]
# mapDeleteKey myMap $key
# echo "Map After:"
# printArray myMap
# echo

#//test array sort functions
# echo "Array Before:"
# printArray myArr
# arraySortAsc myArr
# #arraySortDesc myArr
# echo "Array After:"
# printArray myArr
# echo "${myArr[@]}"

#//test last index
# index=$(arrayLastIndex myArr)
# echo "Last Index: $index"
# printArray myArr