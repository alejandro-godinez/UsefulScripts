#!/bin/bash

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

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

#//append multiple to existing array
echo "Add multiple entries in one go (A, B, C)"
myArr=("${myArr[@]}" "A" "B" "C")
for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done
echo ""

#//Get the count of entries for an array
echo "Array Value Count: ${#myArr[@]}"