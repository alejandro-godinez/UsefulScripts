#!/bin/bash

#-----------------------------------------------------------------------------
#  Bash Notes: 
#    [@]   - expands values to separate words
#    ${!   - the ! here expands the indices (keys) instead of the values
#    keys  - array keys don't need to be quoted
#-----------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//associative array
echo "Declare Associative Array"

#//explicit associative array using 'declare -A'
declare -A myArr=(["one"]="uno" ["two"]="dos" ["three"]="tres") 
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
echo ""

#//assign values to existing index position 
echo "Assign '2' to index [two]"
myArr["two"]="2"
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
echo ""

#//add value to position that doesn't exist
echo "Assign 'cinco' to index [five]"
myArr[five]="cinco"
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
echo ""

#//Get the count of entries for an array
echo "Array Value Count: ${#myArr[@]}"

#//print values directory by index key, NOTE: keys don't need to be quoted 
echo "Print Two and Five index positions"
echo "  two -> ${myArr[two]}"
echo "  five -> ${myArr[five]}"
echo ""

#//check a key that exists in the array
if [[ -v myArr['five'] ]]; then
  echo "The key 'five' exists in the array"
fi

#//check a key does not exist in the array
if [[ ! -v myArr['DNE'] ]]; then
  echo "The key 'DNE' does not exist in the array"
fi