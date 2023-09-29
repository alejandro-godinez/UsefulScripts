#!/bin/bash
#-----------------------------------------------------------
# This script will create the .nanorc file in the home
# directory that is needed to enable the code highlighting
# in the nano editor
#-----------------------------------------------------------

set -u # error on unset variable
set -e # exit on error

nanoDir=/usr/share/.nano/
nanoRcFile=~/.nanorc

# define list of libraries and import them (from the project)
declare -a libs=( ../linux/lib/logging.sh ../linux/lib/arguments.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: createNanoRCFile.sh [option]"
  echo "  This script will create the nanorc file in the home directory"
  echo ""
  echo "  Options:"
  echo "    -h           This help info"
  echo "    -v           Verbose/debug output"
  echo "    -a           Add all nano syntax files from share directory when user highlight is not enabled"
  echo ""
  echo "Examples:"
  echo "  ./install.sh -n bashdoc"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param $1 - array of argument values provided when calling the script
function processArgs {
  
  # initialize expected options
  addOption "-h"
  addOption "-v"
  addOption "-a"

  # perform parsing of options
  parseArguments "$@"

  #printArgs
  #printRemArgs
  
  # check for help
  if hasArgument "-h"; then
    printHelp
    exit 0
  fi

  # check for vebose/debug
  if hasArgument "-v"; then
    DEBUG=true
  fi
}


#< - - - Main - - - >

# enable logging library escapes
escapesOn

# check the command arguments
processArgs "$@"

echo "Nano Share Directory: ${nanoDir}"
echo "Nano RC File: ${nanoRcFile}"

#//delete the existing .nanorc file if it exists
if [ -f ${nanoRcFile} ]; then
  #TODO: check with user if they want to delete existing
  
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
