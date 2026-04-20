#!/bin/bash

# print working directory for reference
pwd

# find all .git directories and store the output in an array
declare -a findOutput
mapfile -t findOutput < <(find . -type d -name .git)

# find and loop through all .git directories
for repo in "${findOutput[@]}"
do
  # get the repo parent directory
  repoDir=$(dirname "${repo}")

  #print out the directory without newline
  echo -n "${repoDir} -> "

  #get origin URL for the repo
  origUrl=$(git -C "${repoDir}" config --get remote.origin.url)

  echo "${origUrl}"

done
