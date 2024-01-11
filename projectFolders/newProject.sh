#!/bin/bash
#-------------------------------------------------------------------------------------------
# Create a new project work folder for the specified ticket number and description.  
# A copy of the template folder is copied to the current working directory or a specific
# output path if the provided option (-o) is used. The template directory is expected to
# be installed to a data home directory but can be changed to be elsewhere.
#
# @version 2023.12.19
#
# Usage:<br>
# <pre>
# newProject.sh [options] <ticket> [description]
#   -h           This help info
#   -v           Verbose/debug output
#   -o path      Output path
# </pre>
# 
# Examples:
# <pre>
# ./newProject.sh ABC-1245 "New script to create project folder"
# ./newProject.sh -o "01-Assigned" "ABC-1245" "New script to create project folder"
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
NC='\033[0m'       # No Color
RED='\033[0;31m'
CYN='\033[1;36m'

# configuration file
CONFIG_FILE=~/data/projectFolders/projects.config

# path to template folder
TEMPLATE_PATH=~/data/projectFolders/Template

# project tracking base url, when present creats url link file
LINK_URL=

# additional file extension to insert in file name (file.[ext].url), NOTE: Windows hides the url extension
LINK_EXT=

# output path to save document file, default to current directory
OUTPUT_PATH="."

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/prompt.sh ~/lib/config.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: newProject.sh [options] <ticket> [description]"
  echo "  Create a new project folder from the template in the current working directory."
  echo ""
  echo "  Options:"
  echo "    -h           This help info"
  echo "    -v           Verbose/debug output"
  echo "    -o path      Output path"
  echo ""
  echo "Examples:"
  echo "  ./newProject.sh ABC-1245 \"New script to create project folder\""
  echo "  ./newProject.sh -o \"01-Assigned\" \"ABC-1245\" \"New script to create project folder\""
}

# Load configuration properties from config file
function loadConfig {
  if [ -z $CONFIG_FILE ]; then
    log "Config file was not defined"
    return
  fi

  log "Config File: $CONFIG_FILE"

  # return if the config file does not exists, not required
  if [ ! -e $CONFIG_FILE ]; then
    log "Config file was not found"
    return
  fi

  # load the link url property
  logN "Link URL: "
  if hasProperty "$CONFIG_FILE" "link.url" ; then
    LINK_URL=$(getProperty "$CONFIG_FILE" "link.url")
    log "$LINK_URL"
  else
    log ""
  fi
  

  # load the link file extension property
  logN "Link EXT: "
  if hasProperty "$CONFIG_FILE" "link.ext"; then
    LINK_EXT=$(getProperty "$CONFIG_FILE" "link.ext")
    log "$LINK_EXT"
  else
    log ""
  fi
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  
  # initialize expected options
  addOption "-v"
  addOption "-h"
  addOption "-o" true
  
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

  # check for output path option
  if hasArgument "-o" ]; then
    OUTPUT_PATH=$(getArgument "-o")
    log "  Output Path: $OUTPUT_PATH"
  fi
}

#< - - - Main - - - >

# enable logging library escapes
escapesOn

# check the command arguments
processArgs "$@"

# load configurations from file
loadConfig

# check if there were no non-option arguments specified
if [[ ! -v REM_ARGS ]]; then
  printHelp
  exit 0
fi

# check that template folder is defined and exists
logAll "${CYN}Template Path:${NC} ${TEMPLATE_PATH}"
log "Checking template folder exists..."
if [[ -z $TEMPLATE_PATH ]]; then
  logAll "${RED}ERROR: Template folder name is not defined${NC}"
  exit 0
fi
if [[ ! -d $TEMPLATE_PATH ]]; then
  logAll "${RED}ERROR: Template folder path not found${NC}"
  exit 0
fi

# debug print REM arguments
argCount=${#REM_ARGS[@]}
log "List Remaining Args: ${argCount}"
for item in "${REM_ARGS[@]}"; do log "  ${item}"; done

# get ticket and description from REM arguments (not options)
ticketNumber="${REM_ARGS[0]}"
logAll "${CYN}Ticket Number:${NC} ${ticketNumber}"
description=""
projectFolder="${ticketNumber}"
if (( argCount > 1 )); then
  description="${REM_ARGS[1]}"
  logAll "${CYN}Description:${NC} ${description}"
  projectFolder="${ticketNumber} - ${description}"
fi

# get otuput path from options if specified
projectDir="${OUTPUT_PATH}/${projectFolder}"
logAll "${CYN}New Project folder:${NC} ${projectDir}"

# get URL link to item if URL was provided
ticketUrl=''
urlFile=''
if [[ -n "${LINK_URL}" ]]; then
  ticketUrl="${LINK_URL}${ticketNumber}"
  logAll "${CYN}Ticket URL:${NC} ${ticketUrl}"

  # generate shortcut file name
  if [[ -n "${LINK_EXT}" ]]; then
    urlFile="${projectDir}/${ticketNumber}.${LINK_EXT}.url"
  else
    urlFile="${projectDir}/${ticketNumber}.url"
  fi
fi

# check to make sure project folder does not already exist
if [[ -d $projectDir ]]; then
  logAll "${RED}ERROR:${NC} Project directory already exists"
  logAll "Exiting script"
  exit 0
fi

# confirm with the user if they want to go ahead and create the project folder
if ! promptYesNo "Do you want to create the project (y/n)?"; then
  logAll "Exiting script"
  exit 0
fi

# copy the template folder create the project
cp -R "${TEMPLATE_PATH}" "${projectDir}"

# rename the notes file with the ticket number
log "Renaming notes file to '${ticketNumber}.notes"
mv "${projectDir}/project.notes" "${projectDir}/${ticketNumber}.notes"

# create url shortcut file if one was created
if [[ -n "${ticketUrl}" ]]; then
  log "Creating url shortcut file to project item"
  touch "$urlFile"
  echo "[InternetShortcut]" >> "$urlFile"
  echo "URL=${ticketUrl}" >> "$urlFile"
fi