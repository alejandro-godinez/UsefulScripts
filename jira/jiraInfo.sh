#!/bin/bash
#------------------------------------------------------------------
# Fetch information for a given jira issue/ticket/work item id
# 
# @version 2024.06.19
# 
# Usage:
# <pre>
#   jiraInfo.sh [options] <issueId>
# </pre>
# 
#------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

# echo print colors
NC='\033[0m' # No Color
RED='\033[0;31m'

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

# JIRA API URLs
BASE_URL="https://jira.atlassian.com"

# user configuration
CONFIG_FILE=~/auth/jira.config
USER=
API_TOKEN=
API_VERSION="rest/api/3"

# JQ command for parsing JSON output, -r option is used to output raw strings without quotes
JQ_CMD="jq -r"

# check if JQ is installed
if ! command -v "jq" &> /dev/null; then
  echo -e "${RED}ERROR: jq command not found. Please install jq to use this script.${NC}"
  exit 1
fi

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/config.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  
  # shellcheck disable=SC1090 # disable warning for dynamic source
  source "$lib"
done

# Print the usage information for this script to standard output.
function printHelp {
  echo "Usage: jiraInfo.sh [-h] [-v] <issueKey>"
  echo "  Print information for the issue key specified"
  echo ""
  echo "  Options:"
  echo "    -h         This help text info"
  echo "    -v         Verbose/debug output"
  echo "    -u         Update jira info output even if it already exists"
  echo ""
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-v"      #verbose
  addOption "-h"      #help
  addOption "-u"      #update output
  
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
    # shellcheck disable=SC2034 # disable warning for unused variable from a library
    DEBUG=true
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
  log "User: $USER"
  API_TOKEN=$(getProperty "$CONFIG_FILE" "apiKey")
  log "API Token: $API_TOKEN"

  # load alternate base url if it was provided
  if hasProperty "$CONFIG_FILE" "base_url"; then
    BASE_URL=$(getProperty "$CONFIG_FILE" "base_url")
  fi
  logAll "$BASE_URL"
}

# Performa a REST get request for issue information
# 
# @param $issueId - the issueId or key
# @output the response from the API request
function jiraFetchIssueDetails {
  issueIdOrKey="$1"

  # Construct the full URL
  local apiUrl="${BASE_URL}/${API_VERSION}/issue/${issueIdOrKey}"

  # perform curl request
  #curl -s --request GET \   ## add -s for silent output
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

# print out the list of args that were not consumed by function (non-flag arguments)
argCount=0
if [[ -v REM_ARGS ]]; then
  argCount=${#REM_ARGS[@]}
  log "List Remaining Args: ${argCount}"
  for item in "${REM_ARGS[@]}"; do log "  ${item}"; done
else
  #log "No Process Arguments Identified"
  printHelp
  exit 0
fi

# get the first value from the REM_ARGS array as the issue key
issueKey="${REM_ARGS[0]}"
log "Issue Key: ${issueKey}"

# get next file name
outputDir="./temp/"
outputFile="${outputDir}${issueKey}.log"
logAll "Output File: ${outputFile}"

# create the output directory if it doesn't exist
if [ ! -d "${outputDir}" ]; then
  mkdir -p "${outputDir}"
fi

issueInfo=""

# check of output file exists, if so no need to request again, just read the file
if [ -f "${outputFile}" ]; then
  logAll "Output file already exists, reading from file..."
  issueInfo=$(cat "${outputFile}")

  # delete the output file and fetch new info if the -u option was provided
  if hasArgument "-u"; then
    rm "${outputFile}"
  fi 
fi

# fetch the issue info from the API if output file does not exist
if [ ! -f "${outputFile}" ]; then
  logAll "Output file does not exist, fetching issue info from API..."

  # create new empty file
  touch "${outputFile}"

  logAll "API URL: ${BASE_URL}/${API_VERSION}/issue/${issueKey}"
  # perform issue info request
  logAll "Getting Issue Info..."
  issueInfo=$(jiraFetchIssueDetails "$issueKey")

  # use jq to pretty the issueInfo json output
  issueInfo=$(echo "$issueInfo" | $JQ_CMD '.')

  # write issue info to file
  echo -n "$issueInfo" > "${outputFile}"
fi

# use jq to extract the issue information 
logAll "----------- Issue Info -----------"
issueId=$(echo "$issueInfo" | $JQ_CMD '.id')
logAll "Issue ID: ${issueId}"
logAll "Issue Key: ${issueKey}"
issueDescription=$(echo "$issueInfo" | $JQ_CMD '.fields.description')
logAll "Issue Description: ${issueDescription}"
issueSummary=$(echo "$issueInfo" | $JQ_CMD '.fields.summary')
logAll "Issue Summary: ${issueSummary}"

# use jq to extract issue type information
logAll "----------- Issue Type Info -----------"
issueType=$(echo "$issueInfo" | $JQ_CMD '.fields.issuetype.name')
logAll "Issue Type: ${issueType}"

# use jq to extract issue status information
logAll "----------- Issue Status Info -----------"
issueStatus=$(echo "$issueInfo" | $JQ_CMD '.fields.status.name')
logAll "Issue Status: ${issueStatus}"

# use jq to extract project information
logAll "----------- Project Info -----------"
projectId=$(echo "$issueInfo" | $JQ_CMD '.fields.project.id')
logAll "Project ID: ${projectId}"
projectKey=$(echo "$issueInfo" | $JQ_CMD '.fields.project.key')
logAll "Project Key: ${projectKey}"
projectName=$(echo "$issueInfo" | $JQ_CMD '.fields.project.name')
logAll "Project Name: ${projectName}"

# use jq to extract creator information
logAll "----------- Creator Info -----------"
creatorName=$(echo "$issueInfo" | $JQ_CMD '.fields.creator.displayName')
logAll "Creator Name: ${creatorName}" 
creatorEmail=$(echo "$issueInfo" | $JQ_CMD '.fields.creator.emailAddress')
logAll "Creator Email: ${creatorEmail}"
creatorAccountId=$(echo "$issueInfo" | $JQ_CMD '.fields.creator.accountId')
logAll "Creator Account ID: ${creatorAccountId}"


# use jq to extract reporter information
logAll "----------- Reporter Info -----------"
reporterName=$(echo "$issueInfo" | $JQ_CMD '.fields.reporter.displayName')
logAll "Reporter Name: ${reporterName}"
reporterEmail=$(echo "$issueInfo" | $JQ_CMD '.fields.reporter.emailAddress')
logAll "Reporter Email: ${reporterEmail}"
reporterAccountId=$(echo "$issueInfo" | $JQ_CMD '.fields.reporter.accountId')
logAll "Reporter Account ID: ${reporterAccountId}"

# use jq to extract assignee information
logAll "----------- Assignee Info -----------"
assigneeName=$(echo "$issueInfo" | $JQ_CMD '.fields.assignee.displayName')
logAll "Assignee Name: ${assigneeName}"
assigneeEmail=$(echo "$issueInfo" | $JQ_CMD '.fields.assignee.emailAddress')
logAll "Assignee Email: ${assigneeEmail}"
assigneeAccountId=$(echo "$issueInfo" | $JQ_CMD '.fields.assignee.accountId')
logAll "Assignee Account ID: ${assigneeAccountId}"

# use jq to extract priority information
logAll "----------- Priority Info -----------"
priorityName=$(echo "$issueInfo" | $JQ_CMD '.fields.priority.name')
logAll "Priority Name: ${priorityName}"
