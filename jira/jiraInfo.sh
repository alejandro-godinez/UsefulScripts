#!/bin/bash
#-----------------------------------------------------------------------------------
# Fetch information for a given jira issue/ticket/work item id
# the request results are cached in a local file for subsequent 
# field lookups.  You can use the -u option to force an update of the cached file.
# 
# @version 2026.07.17
# 
# 
# ### Requirements:
# - The script expects a configuration file at ~/auth/jira.config  
#   - SEE: [Sample Config File](../config/jira_sample.config)
# - The script requires the `jq` command to be installed for parsing JSON output.
#   - SEE: [jq Installation Guide](https://stedolan.github.io/jq/download/)
#   - TIP: ```winget install jqlang.jq -e```
# 
# ### Usage:
# <pre>
# jiraInfo.sh [options] &lt;issueId&gt;
#   Options:
#     -h         This help text info
#     -v         Verbose/debug output
#     -u         Update jira info output even if it already exists
# 
#   Output Options:
#     -f         Print the full jira issue info (default)
#     -b         Print basic info
#     -t         Print type info
#     -s         Print status info
#     -p         Print project info
#     -c         Print creator info
#     -r         Print reporter info
#     -a         Print assignee info
#     -y         Print priority info
# </pre>
#
# ### Usage Example:
# <pre>
# Full Info:     jiraInfo.sh JRA-123
# Specific Info: jiraInfo.sh -b -t -s JRA-123
# Force Update:  jiraInfo.sh -u JRA-123
# </pre>
# 
#-----------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

# echo print colors
NC='\033[0m' # No Color
RED='\033[0;31m'
CYN='\033[0;36m'

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

  #// options for each of the different sections of the jira info output
  echo "  Output Options:"
  echo "    -f         Print the full jira issue info (default)"
  echo "    -b         Print basic info"
  echo "    -t         Print type info"
  echo "    -s         Print status info"
  echo "    -p         Print project info"
  echo "    -c         Print creator info"
  echo "    -r         Print reporter info"
  echo "    -a         Print assignee info"
  echo "    -y         Print priority info"
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
  
  # options for each of the different sections of the jira info output
  addOption "-f"      # full info (default)
  addOption "-b"      # basic info
  addOption "-t"      # type info
  addOption "-s"      # status info
  addOption "-p"      # project info
  addOption "-c"      # creator info
  addOption "-r"      # reporter info
  addOption "-a"      # assignee info
  addOption "-y"      # priority info
  
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

  # if neither of the output options were provided, default to full output
  if ! hasAnyArgument "-f" "-b" "-t" "-s" "-p" "-c" "-r" "-a" "-y"; then
    setArgument "-f" true
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

# Get a specific field value from the issue information JSON
#
# @param $issueInfo - the JSON string containing the issue information
# @param $fieldName - the name of the field to extract (e.g., '.fields.status.name')
# @output the value of the specified field
function getJiraValue {
  local issueInfo="$1"
  local fieldName="$2"

  local fieldValue
  fieldValue=$(echo "$issueInfo" | $JQ_CMD "${fieldName}")
  echo "$fieldValue"
}

#< - - - Main - - - >
#break

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

# check if the issueInfo is empty
if [ -z "$issueInfo" ]; then
  echo -e "${RED}ERROR: Issue info is empty. Please check the issue key and try again.${NC}"
  exit 1
fi

# check if the issueInfo contains an error message
if jq -e '.errorMessages | type == "array" and length > 0' <<< "$issueInfo" > /dev/null 2>&1; then
  errorMessages=$(jq -r '.errorMessages[]' <<< "$issueInfo")
  echo -e "${RED}ERROR: ${errorMessages}${NC}"
  exit 1
fi

# print the basic issue information
if hasAnyArgument "-b" "-f"; then
  logAll "${CYN}----------- Issue Info -----------${NC}"
  issueId=$(getJiraValue "$issueInfo" ".id")
  logAll "Issue ID: ${issueId}"
  logAll "Issue Key: ${issueKey}"
  issueDescription=$(getJiraValue "$issueInfo" ".fields.description")
  logAll "Issue Description: ${issueDescription}"
  issueSummary=$(getJiraValue "$issueInfo" ".fields.summary")
  logAll "Issue Summary: ${issueSummary}"
fi

# print the issue type information
if hasAnyArgument "-t" "-f"; then
  logAll "${CYN}----------- Issue Type Info -----------${NC}"
  issueType=$(getJiraValue "$issueInfo" ".fields.issuetype.name")
  logAll "Issue Type: ${issueType}"
fi

# print the issue status information
if hasAnyArgument "-s" "-f"; then
  logAll "${CYN}----------- Issue Status Info -----------${NC}"
  issueStatus=$(getJiraValue "$issueInfo" ".fields.status.name")
  logAll "Issue Status: ${issueStatus}"
fi

# print the project information
if hasAnyArgument "-p" "-f"; then
  logAll "${CYN}----------- Project Info -----------${NC}"
  projectId=$(getJiraValue "$issueInfo" ".fields.project.id")
  logAll "Project ID: ${projectId}"
  projectKey=$(getJiraValue "$issueInfo" ".fields.project.key")
  logAll "Project Key: ${projectKey}"
  projectName=$(getJiraValue "$issueInfo" ".fields.project.name")
  logAll "Project Name: ${projectName}"
fi

# print the creator information
if hasAnyArgument "-c" "-f"; then
  logAll "${CYN}----------- Creator Info -----------${NC}"
  creatorName=$(getJiraValue "$issueInfo" ".fields.creator.displayName")
  logAll "Creator Name: ${creatorName}" 
  creatorEmail=$(getJiraValue "$issueInfo" ".fields.creator.emailAddress")
  logAll "Creator Email: ${creatorEmail}"
  creatorAccountId=$(getJiraValue "$issueInfo" ".fields.creator.accountId")
  logAll "Creator Account ID: ${creatorAccountId}"
fi


# print the reporter information
if hasAnyArgument "-r" "-f"; then
  logAll "${CYN}----------- Reporter Info -----------${NC}"
  reporterName=$(getJiraValue "$issueInfo" ".fields.reporter.displayName")
  logAll "Reporter Name: ${reporterName}"
  reporterEmail=$(getJiraValue "$issueInfo" ".fields.reporter.emailAddress")
  logAll "Reporter Email: ${reporterEmail}"
  reporterAccountId=$(getJiraValue "$issueInfo" ".fields.reporter.accountId")
  logAll "Reporter Account ID: ${reporterAccountId}"
fi

# print the assignee information
if hasAnyArgument "-a" "-f"; then
  logAll "${CYN}----------- Assignee Info -----------${NC}"
  assigneeName=$(getJiraValue "$issueInfo" ".fields.assignee.displayName")
  logAll "Assignee Name: ${assigneeName}"
  assigneeEmail=$(getJiraValue "$issueInfo" ".fields.assignee.emailAddress")
  logAll "Assignee Email: ${assigneeEmail}"
  assigneeAccountId=$(getJiraValue "$issueInfo" ".fields.assignee.accountId")
  logAll "Assignee Account ID: ${assigneeAccountId}"
fi

# print the priority information
if hasAnyArgument "-P" "-f"; then
  logAll "${CYN}----------- Priority Info -----------${NC}"
  priorityName=$(getJiraValue "$issueInfo" ".fields.priority.name")
  logAll "Priority Name: ${priorityName}"
fi
