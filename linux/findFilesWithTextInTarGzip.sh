#!/bin/bash

#-----------------------------------------------------------
#This script will search the contents of any '.tar.gz' file
#in the specified directory for entries with matching
#specified search text.
#
#Usage:
#  findFileWithTextInTarGzip.sh <search> [tgzFilter]
#
#  search    - the text in the file content to search for
#  tgzFilter - additional limit to the list of tgz files that will be searched.
#
#  Example:  findFileWithTextInTarGzip.sh starcrest 2018
#   - this will list '*2018*.tar.gz' files and search for entries containing 'starcrest'
#
#-----------------------------------------------------------

#//check if missing parameters or user specified 'help'
if [[ -z "${1// }" || "${1}" == "help" ]]; then
  echo "This script will search the contents of any '.tar.gz' file"
  echo "in the specified directory for entries with matching"
  echo "specified search text"
  echo ""
  echo "Usage: "
  echo "  findFileInTarGzip.sh <search> [tgzFilter]"
  echo ""
  echo "  search - the text in the file's name to search for"
  echo "  tgzFilter - additional limit to the list of tgz files that will be searched."
  echo ""
  echo "Example: findFileInTarGzip.sh test.txt 2018"
  echo "  - this will list '*2018*.tar.gz' files and search entries containing 'test.txt'"
  echo ""
  exit 1
fi
search=$1

#//if filter is not supplied default to all '.tar.gz' files
if [ -z "${2// }" ]; then
  tgzFilter="*.tar.gz"
else
  tgzFilter="*${2}*.tar.gz"
fi
echo "FILTER: ${tgzFilter}"

#//obtain the current working directory
dir=$( pwd )
echo "DIR: ${dir}"
if [[ ! -d $dir ]]; then
  echo "Specified path is not a directory."
  exit 1
fi

#//list all file using the filter and loop through them
#for f in $( find ${dir} -maxdepth 1 -name "${tgzFilter}" -type f )
for f in $( find ${dir} -name "${tgzFilter}" -type f )
do 
  #//keep track of iteration count and print status update indicator
  iter=$(( iter+1 ))
  if [[ $(( $iter%50 )) -eq 0 ]]; then
    echo -n "."
  fi 

  #//perform grep serch on the tar listing output and capture the located lines
  result=$( zcat ${f} | strings | grep ${search} )

  #//check if grep found something (success)
  if [[ $? -eq 0 ]]; then
    echo ""
    echo ${f}
    echo ${result}
  fi

done

echo ""
echo "DONE"
