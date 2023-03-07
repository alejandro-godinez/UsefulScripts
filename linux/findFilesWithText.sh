#!/bin/bash
#-----------------------------------------------------------
#This script will search the contents of file in
#sub-directories from the working path for content that
#matches the specified search text.
#-----------------------------------------------------------


#//check if missing parameters or user specified 'help'
if [[ $# -eq 0 ]] || [[ -z "${1// }" || "${1}" == "help" ]]; then

  echo "Usage: "
  echo "  findFilesWithText.sh <search> [filter]"
  echo ""
  echo "  search - the text in the file's name to search for"
  echo "  filter - additional limit to the list of tgz files that will be searched."
  echo ""
  echo "Example: findFileWidthText.sh 'hello' txt"
  echo "  - this will list '*.txt' files and search entries containing 'hello'"
  echo ""
  exit 1
fi 
search=$1
echo "SEARCH: ${search}"


#//if filter is not supplied default to all '.tar.gz' files
if [ -z "${2// }" ]; then
  filter=""
else
  filter="-name ${2}"
fi
echo "FILTER: ${filter}"


for f in $( find -type f ${filter} )
do 
  #//perform grep search on file and capture the located lines
  result=$( grep ${search} ${f} )
  if [ -z "${result// }" ]; then
    echo -n "."
  else
    echo ${f}
  fi
done
