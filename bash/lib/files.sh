#!/bin/bash
#-------------------------------------------------------------------------------
# Library of common functions for manipulating files and directories.
#
# Import Sample Code:
# <pre>
# if [[ ! -f ~/lib/files.sh ]]; then
#   echo "ERROR: Missing files.sh library"
#   exit
# fi
# source ~/lib/files.sh
# </pre>
#-------------------------------------------------------------------------------

# Get the next file name increasing the number suffix 
# 
# @param $filePath - full file path
function getNextOutputFile {
  local filePath="$1"
  
  # get the file's seperate directory and file name
  local fileDir
  local fileName
  fileDir=$(dirname "$filePath")
  fileName=$(basename "$filePath")

  local fileExt="${fileName##*.}"
  
  # get the base file name (no ext)
  local baseFileName="${fileName%.*}"

  # get a count of file with same base file name
  local fileCount
  fileCount=$(find "$fileDir" -mindepth 1 -maxdepth 1 -type f -name "$baseFileName*" | wc -l)

  # increment file count by one for next file name
  local fileCount=$((++fileCount))
  
  echo "${fileDir}/${baseFileName}_${fileCount}.${fileExt}"
}