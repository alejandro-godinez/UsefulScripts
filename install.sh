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
# version: 2023.6.23
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

# set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

# numeric regex
RGX_NUM='^[0-9]+$'

# indexed array of arguments that are not options/flags
declare -a ARG_VALUES

# array of directories that contain scripts to be installed
declare -a SOURCE_DIRS=("linux" "git" "bashdoc")

# variable for selected project directory 
projDir=""

# install path
binInstallPath=~/bin/
#binInstallPath=~/temp/bin/  #testing
libInstallPath=~/lib/
#libInstallPath=~/temp/lib/  #testing

#//search depth
IS_MOCK=false

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: install.sh [-h] [-v] "
  echo "  This script will perform installation and detect updates of scripts."
  echo ""
  echo "  Options:"
  echo "    -h      This help info"
  echo "    -v      Verbose/debug output"
  echo "    -m      Mock run, will display what will be installed and updated"
}


# Process and capture the common execution options from the arguments used when
# running the script. All other arguments specific to the script are retained
# in array variable.
# 
# @param $1 - array of argument values provided when calling the script
function processArgs {
  log "Arg Count: $#"
  while (( $# > 0 )); do
    arg=$1
    log "  Argument: ${arg}"
    
    # the arguments to the next item
    shift 
    
    # check for verbose
    if [ "${arg^^}" = "-V" ]; then
      DEBUG=true
      continue
    fi
    
    # check for help
    if [ "${arg^^}" = "-H" ]; then
      printHelp
      exit 0
    fi

    if [ "${arg^^}" = "-M" ]; then
      IS_MOCK=true
      continue
    fi
       
    # keep arguments that are not options or values from the option
    log "    > Adding $arg to rem arg list"
    ARG_VALUES+=("$arg")
  done
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
function installScripts {
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

  # Loop through each of the file_list values
  local destFile=""
  local fileName=""
  for srcFile in $fileList; do
    logAll "$srcFile"

    # get the base file name
    fileName=$(basename $srcFile)
    log "  File Name: ${fileName}"
    
    # build destination path for this file
    destFile="${destDir}${fileName}"
    log "  Dest File: ${destFile}"

    # install file if it does not exist
    if [[ ! -f $destFile ]]; then
      logAll "  ${GRN}Install:${NC}$destFile"

      #//dont perform copy if this is a mock run
      if [ "$IS_MOCK" = true ]; then continue; fi

      cp "$srcFile" "$destFile"
      continue
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
      if [ "$IS_MOCK" = true ]; then continue; fi

      cp "$srcFile" "$destFile"
      continue
    fi
  done
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

# print out the list of args that were not consumed by function (non-flag arguments)
argCount=0
if [[ -v ARG_VALUES ]]; then
  argCount=${#ARG_VALUES[@]}
  log "List Remaining Args: ${argCount}"
  for item in "${ARG_VALUES[@]}"; do log "  ${item}"; done
fi

log "Prompting user for install..."
if [ "$IS_MOCK" = true ]; then logAll "${PUR}--- MOCK RUN ---${NC}"; fi
if ! promptForInstall ; then
  logAll "${RED}ERROR:${NC} Invalid option selected"
fi

logAll "${U_CYN}BIN Scripts...${NC}"
installScripts "$projDir"
logAll "${U_CYN}LIB Scripts...${NC}"
installScripts "$projDir" "lib"