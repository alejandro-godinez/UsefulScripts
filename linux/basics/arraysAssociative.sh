#!/bin/bash

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
