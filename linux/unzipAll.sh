#!/bin/bash
#-------------------------------------------------------------------------------
# Unzips all tar.gz file in the current directory
#-------------------------------------------------------------------------------

#//list and loop through tgz file in the current directory only
for tgzFile in $( find ./ -maxdepth 1 -type f -name '*.tar.gz' )
do 
  echo $tgzFile
  tar -zxvf $tgzFile
done
