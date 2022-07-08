#!/bin/bash
#-----------------------------------------------------------
# This script will create the .nanorc file in the home
# directory that is needed to enable the code highlighting
# in the nano editor
#-----------------------------------------------------------
nanoDir=/usr/share/nano/
nanoRcFile=~/.nanorc

echo "Nano Share Directory: ${nanoDir}"
echo "Nano RC File: ${nanoRcFile}"

#//delete the existing .nanorc file if it exists
if [ -f ${nanoRcFile} ]; then
  echo "Deleting the .nanorc file: ${nanoRcFile}"
  rm ${nanoRcFile}
fi


#//create blank nano .nanorc file
echo "Creating blank .nanorc file"
touch  ${nanoRcFile}

#//append special config options
echo "set tabstospaces" >> ${nanoRcFile}
echo "set tabsize 2" >> ${nanoRcFile}

#//set some commented options that can be toggled by user and if version of nano allows
echo "#set whitespace \">.\"" >> ${nanoRcFile}
echo "#set autoindent" >> ${nanoRcFile}
echo "#set mouse" >> ${nanoRcFile}
echo "#set linenumbers" >> ${nanoRcFile}

#//add a commented include statement for the unibasic language
echo "#include ~/nano/unibasic.nanorc" >> ${nanoRcFile}

#//loop through syntax file in nano share directory
for file in  $( ls ${nanoDir} )
do
  #//check if this is not a file
  if [ ! -f ${nanoDir}${file} ]; then 
    echo -n "_"
    continue
  fi

  echo -n "."
  #echo "${nanoDir}${file}"
  echo "include ${nanoDir}${file}" >> ${nanoRcFile}
done
echo ""
echo "Done"

lineCount=$( wc -l ${nanoRcFile} )
echo "New file line count: ${lineCount}"
