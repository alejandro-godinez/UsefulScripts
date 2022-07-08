#!/bin/bash

#----------------------------------------------------------------
#This script will find the largest files for the specified
#directory recursively.

#Usage:
#  findLargestFiles.sh [path]
#    path - alternative to the working directory (default)
#----------------------------------------------------------------

#//if dir is not supplied default to current path
if [ -z "$1" ]; then
  dir=$( pwd -P )
else
  dir=$1
fi
echo "DIR: ${dir}"

if [[ -d $dir ]]; then
  #// size, user, group, permissions, path
  #find $dir -type f -printf "%12s %u:%g\t%M\t%p\n" | sort -n | tail

  #// size, user, path
  #find $dir -type f -printf "%s\t%u\t%p\n" | sort -n | tail
  find $dir -type f -printf "%12s %u %p\n" | sort -n | tail
  #find $dir -maxdepth 1 -type f -printf "%12s %u %p\n" | sort -n | tail

else
  echo "Specified path is not a directory: $dir"
  exit 1
fi
