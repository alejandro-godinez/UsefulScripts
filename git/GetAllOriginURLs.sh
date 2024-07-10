#!/bin/bash

# print working directory for reference
pwd

# find and loop through all .git directories
for repo in $( find -type d -name .git )
do
  # get the repo parent directory
  repoDir=$(dirname "${repo}")

  #print out the directory without newline
  echo -n "${repoDir} -> "

  #get origin URL for the repo
  origUrl=$(git -C "${repoDir}" config --get remote.origin.url)

  echo "${origUrl}"

done
