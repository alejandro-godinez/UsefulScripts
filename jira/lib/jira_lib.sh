#!/bin/bash

#-------------------------------------------------------------------------------
# Library for jira request and parsing functionality.
#-------------------------------------------------------------------------------

JIRA_URL="https://jira.atlassian.com"
JIRA_API_VERSION="rest/api/3"
JIRA_USER=
JIRA_API_TOKEN=

#//common jira content field values
#JIRA_CONST_ERROR=".errorMessages"

# Check if JQ is installed
# 
# @return - 0 (zero) when true, 1 otherwise
function hasJqInstalled {
  command -v "jq" &> /dev/null
  return $?
}

# Pretty print a JSON string using jq
#
# @param jsonString - the JSON string to pretty print
# @output - the pretty printed JSON
function prettyPrintJson {
  local jsonString="$1"
  echo "$jsonString" | jq -r '.'
}

# Check if the provided jira content contains error messages
#
# @param jiraContent - the JSON string containing the jira content
# @return - 0 (zero) when true, 1 otherwise
function jiraHasErrors {
  local jiraContent="$1"
  
  # jq -e returns 0 (true) if the filter succeeds, and 1 (false) if it fails. We use this to check if the errorMessages array exists and has a length greater than 0.
  if jq -e '.errorMessages | type == "array" and length > 0' <<< "$jiraContent" > /dev/null 2>&1; then
    return 0
  fi

  return 1
}

# Get the error messages from the provided jira content
#
# @param jiraContent - the JSON string containing the jira content
# @output - the error messages, one per line
function getJiraErrorMessages {
  local jiraContent="$1"
  
  if jiraHasErrors "$jiraContent"; then
    errorMessages=$(jq -r '.errorMessages[]' <<< "$jiraContent")
    echo "$errorMessages"
  fi
}

# Performa a REST get request for issue information
# 
# @param $issueId - the issueId or key
# @output the response from the API request
function fetchJiraIssue {
  issueIdOrKey="$1"

  # Construct the full URL
  local apiUrl="${JIRA_URL}/${JIRA_API_VERSION}/issue/${issueIdOrKey}"

  # perform curl request
  #curl -s --request GET \   ## add -s for silent output
  curl --request GET \
    --url "${apiUrl}" \
    --user "${JIRA_USER}:${JIRA_API_TOKEN}" \
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
  fieldValue=$(echo "$issueInfo" | jq -r "${fieldName}")
  echo "$fieldValue"
}

# - - - TESTING - - -
