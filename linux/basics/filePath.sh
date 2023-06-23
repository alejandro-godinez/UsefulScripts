#!/bin/bash

#-------------------------------------------------------------------------------------
#  Bash Notes:
#    ${parameter##word} - Part of bash parameter expansion where the word is expanded
#                         to a pattern and deleted from the parameter. "##" matches
#                         the longest, where "#" would be the shortest
#-------------------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

filePath="/usr/local/bin/test.sh"
echo "Path: $filePath"

#Using bash commands
pathOnly=$(dirname $filePath)
echo "Dirname: $pathOnly"
fileName=$(basename $filePath)
echo "Basename: $fileName"

#Using parameter expansion
pathOnly=${filePath%/*}
echo "Directory (expansion): $pathOnly"
fileName=${filePath##*/}
echo "Name (expansion): $fileName"
