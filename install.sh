#!/bin/bash
#-------------------------------------------------------------------------------
# This script will perform installation and detect updates of scripts. Files are
# identified as install if it does not exist. Updates are detect by comparing
# and finding a difference in the md5 hash of the project script and the local
# copy. The installation of the data folder for projects needs be explicit (-d)
# and is a simple recursive copy (cp -r) without comparision.
# 
# Notes:<br>
# - Files will be overwritten, any local config changes made will be lost
# - Any change in your local copy will be detected as needing an update
# <br>
# 
# @version: 2024.1.29
# 
# TODO:<br>
# - Better detect changes in script, maybe by version number if one exists
# 
# Usage:<br>
# <pre>
# install.sh [option]
# 
# Options:
#   -h           This help info
#   -v           Verbose/debug output
#   -m           Mock run, will display what will be installed and updated
#   -a           Install all pre-defined projects
#   -d           Perform installation of data files
#   -n filename  install a single file matching the name specified, name must be exact, '.sh' extension is assumed
# </pre>
# 
# Examples:
# <pre>
# install.sh -d
# - enable project data folder installation
# install.sh -n spinner
# - install the spinner.sh script from the linux library project
# </pre>
#-------------------------------------------------------------------------------

set -u # error on unset variable
set -e # exit on error

# use of associative arrays requires bash 4 and greater
if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need at least bash-4.0 to run this script."
  exit 1
fi

# echo print colors
NC='\033[0m'       # No Color
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
YEL='\033[1;33m'
PUR='\033[0;35m'
U_CYN='\033[4;36m'


# define list of libraries and import them
declare -a libs=( ./linux/lib/logging.sh ./linux/lib/arguments.sh ./linux/lib/prompt.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

# set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

# numeric regex
RGX_NUM='^[0-9]+$'
# library folder regex
RGX_LIB='/lib/'

# array of directories that contain scripts to be installed
declare -a PROJECT_DIRS=("linux" "git" "bashdoc" "timelog" "projectFolders")

# variable for selected project directory 
projDir=""

# install path
binInstallPath=~/bin/
libInstallPath=~/lib/
dataInstallPath=~/data/

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
  echo "    -a           Install all pre-defined projects"
  echo "    -d           Perform installation of data files"
  echo "    -n filename  install a file matching the name specified, name must be exact, '.sh' extension is assumed"
  echo ""
  echo "Examples:"
  echo "  install.sh -d"
  echo "  - enable project data folder installation"
  echo "  install.sh -n spinner"
  echo "  - install the spinner.sh script from the linux library project"
}


# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  
  # initialize expected options
  addOption "-v"
  addOption "-h"
  addOption "-m"
  addOption "-a"
  addOption "-d"
  addOption "-n" true

  # perform parsing of options
  parseArguments "$@"
  
  # check for help
  if hasArgument "-h"; then
    printHelp
    exit 0
  fi

  # check for vebose/debug
  if hasArgument "-v"; then
    DEBUG=true
    printArgs
    printRemArgs
  fi

  # check for mock run
  if hasArgument "-m"; then
    IS_MOCK=true
  fi
}

# Ask user which project they would like to install from the set
# 
# @return - exit value of zero (truthy) indicates installDir variable set, 1 otherwise
function promptForInstall {
  # reset install directory
  installDir=""

  local optionNo=0
  local optionCount=${#PROJECT_DIRS[@]}
  log "Option Count: ${optionCount}"

  # print the list of source options
  logAll "${U_CYN}Project To Install:${NC}"
  local prompt="Enter number of project to install or Q to Quit: "
  if promptSelection "$prompt" "${PROJECT_DIRS[@]}"; then
    # capture the user selection reply
    projDir=$REPLY
    log "Selected Option: $projDir"
    
    # return success value
    return 0
  else
    if [ "${REPLY^^}" = "Q" ];  then
      logAll "Quitting Script"
      exit 0
    else
      logAll "${RED}ERROR:${NC} Invalid Input" 
      # return error code
      return 1
    fi
  fi
}

# Perform installation of scripts for the specified project sub directory.
# 
# @param projDir - the project sub-directory from which to install scripts
# @param isLib - indicator to process lib sub folder
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

# Perform installation of the data folder files to for the project
#
# @param projDir - the project sub-directory from which to install scripts
function installData {
  # add data sub directory to the project source
  local projSubDir="${1}/data"

  # add the project folder name to the install path
  local destDir="${dataInstallPath}${1}"

  log "Project Sub Dir: ${projSubDir}"
  log "Dest Path: ${destDir}"

  #  check if a data directory exists
  if [ ! -d "$projSubDir" ]; then
    logAll "  No project data directory"
    return 0
  else
    local fileList=$(find $projSubDir -mindepth 1)
    # log the files from the data folder
    for srcFile in $fileList; do logAll "$srcFile"; done
  fi

  # dont perform copy if this is a mock run
  if [ "$IS_MOCK" = true ]; then return; fi

  # perform a recursive copy of the project data folder to the destination, ommit the 'data' folder itself (hence 'src/data/.' )
  cp -R "${projSubDir}/." "${destDir}"
}

# Perform the work to find the single file to install specified throug script option
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
  if ! promptYesNo "Continue with install? [Y/N]: "; then
    logAll "Quitting Script"
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
# @param file - the file to install
# @param dest - the destination path into which file should be installed
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
# @param fileName - the file name to search
# @return - 0 (zero) when match was found, 1 otherwise
# @output - the file path, writtent to standard output
function findFile {
  local fileName="$1"

  # perform find command and capture to an array
  #fileList=$( find -type f -iname "${fileName}.sh" )
  #readarray -d '' fileList < <(find . -type f -iname "${fileName}.sh" -print0)
  
  # ignore (prune) 'test' directory
  readarray -d '' fileList < <(find . -type d -name "test" -prune -o -iname "${fileName}.sh" -print0)

  # check if file list was empty/undefined
  if [[ -z "${fileList[@]}" ]]; then
    echo ""
    return 1
  fi

  # echo the path
  echo "${fileList[0]}"
  return 0
}

# Check if the specified path contains a lib folder
# 
# @param path - the path to check
# @return - 0 (zero) when true, 1 otherwise
function pathHasLibFolder {
  if [[ "$1" =~ $RGX_LIB ]]; then
    return 0
  fi
  return 1
}

#< - - - Main - - - >
# @break

# enable logging library escapes
escapesOn

# check the command arguments
processArgs "$@"

# create the install bin path if it does not exist
logAll "${GRN}BIN Path:${NC} $binInstallPath"
log "Checking if the BIN install path exists"
if [ ! -d "$binInstallPath" ]; then
  log "${YEL}  Creating BIN install directory${NC}"
  mkdir "$binInstallPath"
fi
logAll "${GRN}LIB Path:${NC} $libInstallPath"
log "Checking if the LIB install path exists"
if [ ! -d "$libInstallPath" ]; then
  log "${YEL}  Creating LIB install directory${NC}"
  mkdir "$libInstallPath"
fi
logAll "${GRN}DATA Path:${NC} $dataInstallPath"
log "Checking if the DATA install path exists"
if [ ! -d "$dataInstallPath" ]; then
  logAll "${YEL}  Creating DATA install directory${NC}"
  mkdir "$dataInstallPath"
fi

# output mock run indicator
if [ "$IS_MOCK" = true ]; then logAll "${PUR}--- MOCK RUN ---${NC}"; fi

# check if option for all project install
if hasArgument "-a"; then
  # loop through and install all predefined directories
  for projDir in "${PROJECT_DIRS[@]}"; do
    logAll "${U_CYN}${projDir}${NC}"
    logAll "${BLU}BIN Scripts...${NC}"
    installProject "$projDir"
    logAll "${BLU}LIB Scripts...${NC}"
    installProject "$projDir" "lib"
    if hasArgument "-d"; then
      logAll "${BLU}DATA Files...${NC}"
      installData "$projDir"
    fi
  done
  exit 0
fi

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

logAll "${U_CYN}${projDir}${NC}"
logAll "${BLU}BIN Scripts...${NC}"
installProject "$projDir"
logAll "${BLU}LIB Scripts...${NC}"
installProject "$projDir" "lib"
if hasArgument "-d"; then
  logAll "${BLU}DATA Files...${NC}"
  installData "$projDir"
fi