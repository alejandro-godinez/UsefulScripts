#!/bin/bash
#-------------------------------------------------------------------------------------------
# Convenience script to re-build all bash documentation files in this project using bashdoc
#
# @version 2023.12.14
#
# Usage:
# <pre>
# rebuildDocs.sh [options]
#   -h        This help info
#   -v        Verbose/debug output
# </pre>
#-------------------------------------------------------------------------------------------

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
BLU='\033[0;34m'
U_CYN='\033[4;36m'

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/spinner.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi
  source "$lib"
done

# array of directories that contain scripts to be installed
declare -a PROJECT_DIRS=("linux" "git" "bashdoc" "timelog" "projectFolders")
#declare -a PROJECT_DIRS=("bashdoc")

# Print the usage information for this script to standard output.
function printHelp {
  echo "Convenience script to re-build all bash documentation files in this project using bashdoc"
  echo ""
  echo "Usage: "
  echo "  rebuildDocs.sh [OPTION]"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  
  # initialize expected options
  addOption "-v"
  addOption "-h"

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
}

# Perform work on one specefic project directory and convert any bash script
# found in the directory.
#
# @param projSubDir - the project sub-directory whose scripts will be processed
# @param isLib - indicator to process lib sub folder
function processDirectory {
  local projSubDir=$1
  local isLib=false

  #  check second parameter for lib
  if (( $# > 1 )); then
    if [ "$2" == "lib" ]; then
      isLib=true
    fi
  fi

  # switch paths to lib sub dir if 'lib' indicator was specified
  if [ "$isLib" = true ]; then 
    # add lib sub directory to source
    projSubDir="$projSubDir/lib"

    #  check if a lib directory exists
    if [ ! -d "$projSubDir" ]; then
      logAll "  No lib scripts"
      return 0
    fi
  fi

  local srcDir="./${projSubDir}"
  log "Source Path: ${srcDir}"

  # get a list of bash script from the source directory, no sub-directories
  local fileList=$(find $srcDir -mindepth 1 -maxdepth 1 -type f -name "*.sh")

  # Loop through and install each file in the list
  for srcFile in $fileList; do
    logAll "$srcFile"

    # perform installation for file
    processFile "$srcFile"
  done
}

# Perform work to run bashdoc on one specific file
# 
# @param file - the script file to process
function processFile {
  local srcFile="$1"
  
  # generate destination docs directory as a sub folder of the file
  local destDir="$(dirname $srcFile)/docs"
  log "Dest Dir: $destDir"

  # perform badh doc conversion on the file
  logAll "Command: bashdoc.sh -o $destDir $srcFile"
  if hasArgument "-v"; then
    ./bashdoc/bashdoc.sh -v -o "$destDir" "$srcFile"
  else
    ./bashdoc/bashdoc.sh -q -o "$destDir" "$srcFile"
  fi
}

#< - - - Main - - - >
# @break

# enable logging library escapes
escapesOn

# check the command arguments
processArgs "$@"

# loop through all predefined project directories
for projDir in "${PROJECT_DIRS[@]}"; do
  logAll "${U_CYN}${projDir}${NC}"

  # process script files in the directory
  logAll "${BLU}BIN Scripts...${NC}"
  processDirectory $projDir
  
  # process extra lib script files
  logAll "${BLU}LIB Scripts...${NC}"
  processDirectory "$projDir" "lib"
done
