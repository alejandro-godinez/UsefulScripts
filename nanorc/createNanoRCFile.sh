#!/bin/bash
#-------------------------------------------------------------------------------
# This script will create the .nanorc file in the home
# directory that is needed to enable the code highlighting
# in the nano editor
# 
# @version 2023.10.05
# 
# Usage:<br>
# <pre>
# createNanoRCFile.sh [option]
# 
# Options:
#   -h           This help info
#   -v           Verbose/debug output
#   -a           Add all nano syntax files from share directory when highlight is not enabled on user's login"
# </pre>
# 
#-------------------------------------------------------------------------------

set -u # error on unset variable
set -e # exit on error

# use of associative arrays requires bash 4 and greater
if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need at least bash-4.0 to run this script."
  exit 1
fi

# echo print colors
NC='\033[0m' # No Color
RED='\033[0;31m'

nanoRcFile=~/.nanorc
#nanoRcFile=~/nanorc
homeNanoDir=~/.nano

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
  echo "    -a           Add all nano syntax files from share directory when highlight is not enabled on user's login"
  echo ""
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

# Generic function to prompt user for input
# 
# @parm $1 - prompt text
# @return - exit value of zero indicates yes (bash no error)
function promptYesNo {
  local promptText=$1
  read -p "${promptText} [Y/N]: "
  # check if user reply is numeric
  if [[ "$REPLY" == "y" ]] || [[ "$REPLY" == "Y" ]]; then
    return 0
  fi
  return 1
}

# Creates a new nanorc file
function createNanoRCFile {
  # create blank nano .nanorc file
  log "Creating blank .nanorc file"
  touch  ${nanoRcFile}

  #//append special config options
  echo "set tabstospaces" >> ${nanoRcFile}
  echo "set tabsize 2" >> ${nanoRcFile}
  echo "set linenumbers" >> ${nanoRcFile}
  echo "set autoindent" >> ${nanoRcFile}

  #//set some commented options that can be toggled by user and if version of nano allows
  echo "#set whitespace \">.\"" >> ${nanoRcFile}
  echo "#set mouse" >> ${nanoRcFile}
  echo "" >> ${nanoRcFile}
}

# add include statements for each of the files in the user share 
function includeSyntaxFromInstall {

  declare -a nanoDirs=( /usr/share/.nano /usr/share/nano)
  local nanoInstallDir=""
  for nanoDir in "${nanoDirs[@]}"; do
    log "$nanoDir"
    if [[ ! -d $nanoDir ]]; then
      nanoInstallDir=$nanoDir
      break
    fi
  done
  
  # test for two possible nano install paths
  if [ -z "${nanoInstallDir}" ]; then
    logAll "${RED}ERROR: user share nano path was not found${NC}"
    return
  fi
  
  # loop through syntax files in nano share directory
  for nanoFile in  $( find "${nanoInstallDir}" -mindepth 1 -maxdepth 1 -type f -name "*.nanorc" ); do
    log "${nanoFile}"

    echo "include ${nanoInstallDir}${nanoFile}" >> ${nanoRcFile}
  done

  log ""
  log "Done"
}

# copies project syantax file to local home nano directory and adds include
# statement to the nanorc file
function includeSyntaxFromProject {

  # create home nano directory if needed
  if [[ ! -d $homeNanoDir ]]; then
    log "Creating the home nano directory"
    mkdir $homeNanoDir
  fi

  # loop through all nanorc syntax file in project
  for nanoFile in $( find -mindepth 1 -maxdepth 1 -type f -name "*.nanorc" ); do 
    log "$nanoFile"

    # copy nanorc files from project to the home nano folder
    cp $nanoFile "${homeNanoDir}/"

    # add an include statement for the syntax file
    fileName=$(basename $nanoFile)
    echo "include ~/.nano/$fileName" >> ${nanoRcFile}
  done

  # add a commented include statement for the unibasic language
  #echo "#include ~/.nano/unibasic.nanorc" >> ${nanoRcFile}
  #echo "#include ~/.nano/.nanorc" >> ${nanoRcFile}
}


#< - - - Main - - - >
# @break

# enable logging library escapes
escapesOn

# check the command arguments
processArgs "$@"

#log "Nano Share Directory: ${nanoDir}"
#log "Nano RC File: ${nanoRcFile}"

# detect if nano rc file already exists
if [ -f ${nanoRcFile} ]; then
  
  # ask user if they want to delete the existing config file
  if ! promptYesNo "Nanorc file already exists, do you want to replace with new copy"; then
    exit 0
  fi

  # delete the existing .nanorc file
  logAll "Deleting the .nanorc file: ${nanoRcFile}"
  rm ${nanoRcFile}
fi

# create a new copy of the nano rc file
logAll "Creating new nanorc file"
createNanoRCFile

logAll "Adding project syntax files"
includeSyntaxFromProject

# when option is specified include installed syntax files
if hasArgument "-a"; then
  logAll "Adding install syntax files"
  includeSyntaxFromInstall
fi

#lineCount=$( wc -l ${nanoRcFile} )
#echo "New file line count: ${lineCount}"