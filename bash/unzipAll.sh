#!/bin/bash
#-------------------------------------------------------------------------------
# Unzips all tar.gz file in the current directory
#-------------------------------------------------------------------------------

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//list and loop through tgz file in the current directory only
# shellcheck disable=SC2044 # disable warning for find in for loop script uses \n as IFS
for tgzFile in $( find ./ -maxdepth 1 -type f -name '*.tar.gz' )
do 
  echo "$tgzFile"
  tar -zxvf "$tgzFile"
done
