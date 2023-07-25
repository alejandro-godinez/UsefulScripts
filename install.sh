#!/bin/bash
#-------------------------------------------------------------------------------
# This script will perform installation and detect updates of scripts. Files are
# identified as install if it does not exist. Updates are detect by comparing
# and finding a difference in the md5 hash of the project script and the local
# copy.
# 
# Notes:<br>
# - Files will be overwritten, any local config changes made will be lost
# - Any change in your local copy will be detected as needing an update
# <br>
# 
# TODO:<br>
# - Add script option to simply install all projects without prompt (-a)
# - Better detect changes in script, maybe by version number if one exists
# 
# version: 2023.7.24
#-------------------------------------------------------------------------------

set -u # error on unset variable
set -e # exit on error

# echo print colors
NC='\033[0m'       # No Color
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
YEL='\033[1;33m'
PUR='\033[0;35m'
U_CYN='\033[4;36m'

# import logging functionality from project
if [[ ! -f ./linux/lib/logging.sh ]]; then
  echo -e "${RED}ERROR: Missing logging.sh library${NC}"
  exit
fi
source ~/lib/logging.sh

# import argument processing functionality
if [[ ! -f ~/lib/arguments.sh ]]; then
  echo -e "${RED}ERROR: Missing arguments.sh library${NC}"
  exit
fi
source ~/lib/arguments.sh

# set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

# numeric regex
RGX_NUM='^[0-9]+$'
# library folder regex
RGX_LIB='/lib/'

# array of directories that contain scripts to be installed
declare -a SOURCE_DIRS=("linux" "git" "bashdoc" "timelog")

# variable for selected project directory 
projDir=""

# install path
binInstallPath=~/bin/
#binInstallPath=~/temp/bin/  #testing
libInstallPath=~/lib/
#libInstallPath=~/temp/lib/  #testing

# mock run variable
IS_MOCK=false

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: install.sh [option]"
  echo "  This script will perform installation and detect updates of scripts."
  echo ""
  echo "  Options:"
  echo "    -h           This help info"
  echo "    -v           Verbose/debug output"
  echo "    -m           Mock run, will display what will be installed and updated"
  echo "    -n filename  install a file matching the name specified, name must be exact, '.sh' extension is assumed"
}


# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param $1 - array of argument values provided when calling the script
function processArgs {
  
  # initialize expected options
  addOption "-v"
  addOption "-h"
  addOption "-m"
  addOption "-n" true

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

  # check for mock run
  if hasArgument "-m"; then
    IS_MOCK=true
  fi
}

# Ask user to confirm if the file that was found is the one intended
# to be installed.
function showYestNoPrompt {
  read -p "Continue with install [Y/N]: "
  # check if user reply is numeric
  if [[ "$REPLY" == "y" ]] || [[ "$REPLY" == "Y" ]]; then
    return 0
  fi
  return 1
}

# Ask user which project they would like to install from the set
# 
# @return - exit value of zero (truthy) indicates installDir variable set
function promptForInstall {
  # reset install directory
  installDir=""

  local optionNo=0
  local optionCount=${#SOURCE_DIRS[@]}
  log "Option Count: ${optionCount}"

  # print the list of source options
  logAll "${U_CYN}Project To Install:${NC}"
  for srcPath in "${SOURCE_DIRS[@]}"; do
    # count number of lines
    optionNo=$((++optionNo))
    logAll "  ${optionNo}. ${srcPath}"
  done
  logAll ""
  read -p "Enter number of project to install or Q to Quit: "

  # check if user reply is numeric
  if [[ "$REPLY" =~ $RGX_NUM ]]; then
    # capture index from option number specified
    optionNo=$((--REPLY))
    log "Option Index: $optionNo"

    # check if the number is within range of option array
    if (( REPLY > -1 )) && (( REPLY < optionCount )); then
      # return the selected path
      projDir=${SOURCE_DIRS[$REPLY]}

      # return success value
      return 0
    fi
    
    # return error value
    return 1
  elif [ "${REPLY^^}" = "Q" ];  then
    logAll "Quitting Script"
    exit 0
  else
    logAll "${RED}ERROR:${NC} Invalid Input"
    
    # return success value
    return 1
  fi
}

# Perform installation of scripts for the specified project sub directory.
# 
# @param $1 - the project sub-directory from which to install scripts
function installProject {
  local projSubDir=$1
  local isLib=false

  #  check second parameter for lib
  if (( $# > 1 )); then
    if [ "$2" == "lib" ]; then
      isLib=true
    fi
  fi

  local destDir="${binInstallPath}"
  # switch paths to lib if 'lib' indicator was specified
  if [ "$isLib" = true ]; then 
    # add lib sub directory to source
    projSubDir="$projSubDir/lib"
    destDir="${libInstallPath}"

    #  check if a lib directory exists
    if [ ! -d "$projSubDir" ]; then
      logAll "  No lib scripts"
      return 0
    fi
  fi
  log "Project Sub Dir: ${projSubDir}"
  log "Dest Path: ${destDir}"
  
  local srcDir="./${projSubDir}"
  log "Source Path: ${srcDir}"
  
  # get a list of bash script from the source directory, no sub-directories
  local fileList=$(find $srcDir -mindepth 1 -maxdepth 1 -type f -name "*.sh")

  # Loop through and install each file in the list
  for srcFile in $fileList; do
    logAll "$srcFile"

    # perform installation for file
    installFile "$srcFile" "$destDir"
  done
}

# Perform the work to find the single file to install
function installSingleFile {
  # get the file name from argument
  fileName=$(getArgument "-n")
  logAll "Serach Name: ${fileName}"

  # search for a matching file
  srcFile=$(findFile "${fileName}")
  if [ -z "${srcFile}" ]; then
    logAll "No Files Found"
    exit 0
  fi
  logAll "File Found: $srcFile"

  # prompt user if the found file should be installed
  if ! showYestNoPrompt ; then
    exit 0
  fi

  # determine if file is in a 'lib' folder
  destDir="${binInstallPath}"
  if pathHasLibFolder "${srcFile}" ; then
    logAll " - Has LIB Folder"
    destDir="${libInstallPath}"
  fi
  log "Dest Path: ${destDir}"

  # perform installation for file
  installFile "$srcFile" "$destDir"
}

# Perform install work for a file
#
# @param $1 - the file to install
# @param $2 - the destination path into which file should be installed
function installFile {
  local srcFile="$1"
  local destDir="$2"

  # get the base file name
  local fileName=$(basename $srcFile)
  log "  File Name: ${fileName}"
  
  # build destination path for this file
  local destFile="${destDir}${fileName}"
  log "  Dest File: ${destFile}"

  # install file if it does not exist
  if [[ ! -f $destFile ]]; then
    logAll "  ${GRN}Install:${NC}$destFile"

    #//dont perform copy if this is a mock run
    if [ "$IS_MOCK" = true ]; then return; fi

    cp "$srcFile" "$destFile"
    return
  fi

  # get hash for both source and destination files
  srcHash=$(md5sum $srcFile | cut -d' ' -f1)
  log "  Src Hash: $srcHash"
  destHash=$(md5sum $destFile | cut -d' ' -f1)
  log "  Dest Hash: $srcHash"

  # update if there is a difference in the files
  if ! [ "$srcHash" == "$destHash" ]; then
    logAll "  ${YEL}Update:${NC}$destFile"
    
    #//dont perform copy if this is a mock run
    if [ "$IS_MOCK" = true ]; then return; fi

    cp "$srcFile" "$destFile"
    return
  fi

  # no install/update performed
  log "  [NO UPDATE]:$destFile"
}

# Find the first file that is found to match the name specified
# 
# @param $1 - the file name to search
function findFile {
  local fileName="$1"

  # perform find command and capture to an array
  #fileList=$( find -type f -iname "${fileName}.sh" )
  readarray -d '' fileList < <(find -type f -iname "${fileName}.sh" -print0)

  # check if file list was empty/undefined
  if [[ -z "${fileList[@]}" ]]; then
    echo ""
    return
  fi

  # echo the path
  echo "${fileList[0]}"
}

# Check if the specified path contains a lib folder
# 
# @param $1 - the path to check
function pathHasLibFolder {
  if [[ "$1" =~ $RGX_LIB ]]; then
    return 0
  fi
  return 1
}

#< - - - Main - - - >

# enable logging library escapes
escapesOn

# check the command arguments
processArgs "$@"

# create the install bin path if it does not exist
if [ ! -d "$binInstallPath" ]; then
  mkdir "$binInstallPath"
fi
if [ ! -d "$libInstallPath" ]; then
  mkdir "$libInstallPath"
fi

# output mock run indicator
if [ "$IS_MOCK" = true ]; then logAll "${PUR}--- MOCK RUN ---${NC}"; fi

# check if option for a single file to install was specified
if hasArgument "-n"; then
  installSingleFile
  exit 0
fi

# show default prompt for project install
log "Prompting user for install..."
if ! promptForInstall ; then
  logAll "${RED}ERROR:${NC} Invalid option selected"
  exit 0
fi

logAll "${U_CYN}BIN Scripts...${NC}"
installProject "$projDir"
logAll "${U_CYN}LIB Scripts...${NC}"
installProject "$projDir" "lib"