#!/bin/bash

set -u #//error on unset variable
set -e #//exit on error

# echo print colors
NC='\033[0m' # No Color
RED='\033[0;31m'

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

# JIRA API URLs
BASE_URL="https://jira.atlassian.com"
API_ISSUE="/rest/api/2/issue/"

# user configuration
CONFIG_FILE=~/auth/jira.config
USER=
API_TOKEN=

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/config.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: jiraInfo.sh [-h] [-v] -j jiraId"
  echo "  Print information for the jira item id specified"
  echo ""
  echo "  Options:"
  echo "    -h         This help text info"
  echo "    -v         Verbose/debug output"
  echo "    -j jiraId  The jira item/issue id"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-v"      #verbose
  addOption "-h"      #help
  addOption "-j" true #jira item id
  
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

  if ! hasArgument "-j"; then
    echo -e "${RED}ERROR: Missing jira item id (-j) ${NC}"
    printHelp
    exit 0
  fi

}

# Perform work to load settings from config file
function loadConfig {
  
  # check to make sure the token file exists
  if [ ! -f $CONFIG_FILE ]; then
    echo -e "${RED}ERROR: Missing jira config file${NC}"
    echo "Config File: ${CONFIG_FILE}"
    exit
  fi

  local propName=""

  # perform a quick check for missing porperties
  local -a essentialProps=("user" "apiKey") 
  for propName in "${essentialProps[@]}"; do
    if ! hasProperty "$CONFIG_FILE" "$propName"; then
      echo -e "${RED}ERROR: Missing '${propName}' configuration${NC}"
      exit
    fi
  done

  # load essential configurations
  USER=$(getProperty "$CONFIG_FILE" "user" )
  API_TOKEN=$(getProperty "$CONFIG_FILE" "apiKey")

  # load alternate base url if it was provided
  if hasProperty "$CONFIG_FILE" "base_url"; then
    BASE_URL=$(getProperty "$CONFIG_FILE" "base_url")
  fi
  logAll "$BASE_URL"
}

# Get the next file name increasing the number suffix 
# 
# @param $filePath - full file path
function getNextOutputFile {
  local filePath="$1"
  
  # get the file's seperate directory and file name
  local fileDir=$(dirname $filePath)
  local fileName=$(basename $filePath)
  local fileExt="${fileName##*.}"
  
  # get the base file name (no ext)
  local baseFileName="${fileName%.*}"

  # get a count of file with same base file name
  local fileCount=$(find "$fileDir" -mindepth 1 -maxdepth 1 -type f -name "$baseFileName*" | wc -l)

  # increment file count by one for next file name
  local fileCount=$((++fileCount))
  
  echo "${fileDir}/${baseFileName}_${fileCount}.${fileExt}"
}

# Perform a get request for issue information
# 
# @param $issueId - the issueId or key
function getIssueInfo {
  issueIdOrKey="$1"

  # generage issue url:
  local apiUrl="${BASE_URL}/${API_ISSUE}/${issueIdOrKey}"

  # perform curl request
  curl --request GET \
    --url "${apiUrl}" \
    --user "${USER}:${API_TOKEN}" \
    --header 'Accept: application/json'
}

#< - - - Main - - - >

# enable logging library escapes
escapesOn

#//process arguments
processArgs "$@"
printRemArgs

# load jira config options
logAll "Loading configuration..."
loadConfig

# get the issue id from the arguments
issueID=$(getArgument "-j")
log "Jira ID: $issueID"

# get next file name
outputDir=~/temp/
outputFile="${outputDir}jiraInfo_${issueID}.log"
logAll "Output File: ${outputFile}"

# check if output file exists
if [ -f "${outputFile}" ]; then
  outputFile=$(getNextOutputFile "$outputFile")
  logAll "New File Name: ${outputFile}"

  # make sure the calculated output file does not exist
  if [ -f $outputFile ]; then
    echo -e "${RED}ERROR: Output file name already exists.${NC}"
    exit
  fi
fi

# create new empty file
touch "${outputFile}"

# perform issue info request
logAll "Getting Issue Info..."
issueInfo=$(getIssueInfo "$issueID")

# perform json pretty formatting if command exists on system
if command -v json_pp @> /dev/null; then
  issueInfo=$(echo -n "$issueInfo" | json_pp)
fi

# write issue info to file
echo -n "$issueInfo" > "${outputFile}"
