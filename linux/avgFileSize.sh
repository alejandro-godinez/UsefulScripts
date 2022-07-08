#!/bin/bash
#---------------------------------------------------------------------------
# This script will get an average file size of all the file
# that meet the specified name filter.
#
# version: 2022.3.4
#
# Usage:
#   avgFileSize.sh <search> [dir]
#
#   search - The search pattern to use when listing files
#            NOTE: add quotes to the pattern
#   dir    - The directory in which to list files, current directory if not specified
#
# Example:  avgFileSize.sh "*.tar.gz"
#     - gets average file size for all '.tar.gz' files in the current directory
#----------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//check if missing parameters or user specified 'help'
if [[ $# -eq 0 ]] || [[ -z "${1// }" || "${1}" == "help" ]]; then
  echo "This script will get an average file size of all the file"
  echo "that meet the specified name filter."
  echo ""
  echo "Usage: "
  echo "  avgFileSize.sh <search> [dir]"
  echo ""
  echo "  search - The filter to use when listing files"
  echo "           NOTE: add quotes to the pattern"
  echo "  dir    - The directory in which to list files, current directory if not specified."
  echo ""
  echo "Example:  avgFileSize.sh '*.tar.gz\'"
  echo "  - gets an average file size for all '.tar.gz' files in the current directory"
  echo ""
  exit 1
fi
search=$1
echo "Search: ${search}"

#//if the directory is not supplied default to current work directory
if [[ $# -le 1 ]] || [[ -z "${2// }" ]]; then
  dir="$( pwd )/"
else
  dir=$2
fi
echo "Dir: ${dir}"

#//check if the specified path is actually a directory
if [[ ! -d $dir ]]; then
  echo "Specified path is not a directory: $dir"
  exit 1
fi


#//find and keep sum of file count and size, print average in KiB
#find "${dir}" -iname "${search}" -type f -exec du -sb {} \; | awk ' { sum+=$1; ++n } END { if (n > 0) print "File Count: " print "Average (bytes): " sum/n/1024; else print "No Files Found" } '

#//find and keep sum of file count and space used, print total, count, and average
find "${dir}" -iname "${search}" -type f -exec du -sb {} \; | awk ' { sum+=$1; ++n } END { if (n > 0) {printf("Total (KiB): %.4f \n", sum/1024); print "File Count: " n ;printf("Average (KiB): %.4f \n", sum/n/1024) }  else print "No Files Found" } '

exit 0
