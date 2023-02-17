#!/bin/bash

#-----------------------------------------------------------------------------
#  Bash Notes: 
#    [@]   - expands values to separate words
#    [*]   - expands array values to a single word separated by IFS char
#    ${!   - the ! here expands the indices (keys) instead of the values
#    <<<   - feeds text to command in stdin
#-----------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//standard array
declare -a myArr=("ccc" "aaa" "B" "bbb" "10" "2" "b" "aa" "A") 

#echo "Initial Order:"
#for index in "${!myArr[@]}"; do echo "  $index -> ${myArr[$index]}"; done

#//perform sort
sortedArr=($(sort <<<"${myArr[*]}"))

echo "Lexical Sort:"
for index in "${!sortedArr[@]}"; do echo "  $index -> ${sortedArr[$index]}"; done

echo "Numeric Sort"
numArr=(3 "5" 7 10 "99" 33 2)
sortedArr=($(sort -n <<<"${numArr[*]}"))
for index in "${!sortedArr[@]}"; do echo "  $index -> ${sortedArr[$index]}"; done

echo "Numeric Reverse Sort"
sortedArr=($(sort -nr <<<"${numArr[*]}"))
for index in "${!sortedArr[@]}"; do echo "  $index -> ${sortedArr[$index]}"; done
