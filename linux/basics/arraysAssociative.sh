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

# use of associative arrays requires bash 4 and greater
if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need at least bash-4.0 to run this script."
  exit 1
fi

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//associative array with upper case keys
echo "Declare Associative Array"
declare -A -u upperArr=(["one"]="uno" ["two"]="dos")
for index in "${!upperArr[@]}"; do echo "  $index -> ${upperArr[$index]}"; done
echo ""

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
else
  echo "The key 'five' does NOT exists in the array"
fi

#//check a key does not exist in the array
if [[ ! -v myArr['DNE'] ]]; then
  echo "The key 'DNE' does not exist in the array"
else
  echo "The key 'DNE' exist in the array"
fi
echo

#//special character in key of array
echo "Handle '$' character in key name"
declare -A myArr=()
key='one$two$three' #//can't be used as key due to varaible expansion
key=${key//$/_} #replace '$' with '_' to avoid expansion
myArr[$key]="hello"
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
echo "Checking if [$key] exists"
if [[ -v myArr[$key] ]]; then
  echo "YES, EXISTS"
  myArr[$key]="${myArr[$key]} world"
else
  echo "NO, EXISTS"
fi
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
echo ""