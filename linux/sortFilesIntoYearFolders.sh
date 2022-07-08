#!/bin/sh
#-------------------------------------------------------------------------------
# This script will list all the files in the current working
# directory and move the file into a sub-folder of the year
# equal to the last modified date.
#
# NOTE: modified date/time is used becuase the birth value isn't implemented on
#       older EXT file systems and cannot be relied.
#
# TODO:
# 1. Improve to use birth value if available and fall back to modified
# 2. Add optional argument to allow user to specify file name filter to target
#
# Version: 2022.3.8
#-------------------------------------------------------------------------------



#//get the current working directory
dir=$( pwd )
echo "Working Directory: ${dir}"

#TODO: Ask User for confirmation before executing
echo "Are you sure you want to move all files into year folders?  (yes|no):"
read userIN

#// check for empty input
if [ -z "${userIN}" ]; then
  echo "No Input"
  exit 1;
fi

if [[ "${userIN}" != "yes" ]]; then
  echo "Canceled, Not Confirmed"
  exit 1
fi


#//check if the specified path is actually a directory
if [[ ! -d $dir ]]; then
  echo "Specified path is not a directory: $dir"
  exit 1
fi

#//get all the files in the directory, ignore year tar.gz files
iter=0
for f in $(find -maxdepth 1 -type f -not -name "20*.tar.gz")
do
  #echo "File Name: ${f}"
  #//keep track of iteration count and print status update indicator
  iter=$(( iter+1 ))
  if [[ $(( $iter%100 )) -eq 0 ]]; then
    echo -n "."
  fi

  #//get the file's modified date/time
  fileDateTime=$(stat -c '%y' $f)
  #echo "  Date: ${fileDateTime}"

  #//get only the year from the full date
  fileYear=$(date -d "${fileDateTime}"  +"%Y")
  #echo "  Year: ${fileYear}"

  #//create the year directory if it does not already exist
  if [[ ! -d "${fileYear}" ]]; then
    mkdir "${fileYear}"

    #//check if we couldn't create the directory
    if [[ ! -d "${fileYear}" ]]; then
      echo "Unable to create the ${fileYear} year directory"
      exit 1
    fi
  fi

  #//move the file into the year directory (cp -p = perserve mode)
  #echo "  Move: ${f} --> ${fileYear}/"
  mv "${f}" "${fileYear}/"
done
