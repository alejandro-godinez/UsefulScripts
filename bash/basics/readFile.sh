#!/bin/bash

#---------------------------------------------------------------------------------
#  Bash Notes: 
#    <                - input stream redirect
#    IFS= (or IFS='') - prevents leading/trailing whitespace from being trimmed.
#---------------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

#//define the input file
inputFile=readme.md

lineNo=0
lineNoPadded="000"

#//loop through lines of input file (-r pevent backslash escapes)
while IFS= read -r line; do
  #//count number of lines
  lineNo=$((++lineNo))
  
  #pad line number with spaces
  lineNoPadded=$(printf %4d $lineNo)
  
  #pad line number with zeros
  #lineNoPadded=$(printf %04d $lineNo)
  
  #//print line content with line number
  echo "$lineNoPadded: $line"
  
done < $inputFile