<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [jira_lib.sh](../jira_lib.sh)

 Library for performing jira issue requests and parsing functionality.

 @version: 2026.07.18

 ### Requirements:
 - The script requires the `jq` command to be installed for parsing JSON output.
 Without jq you can perform fetch requests but you will not be able to parse output
 for field values.
   - SEE: [jq Installation Guide](https://stedolan.github.io/jq/download/)
   - TIP: ```winget install jqlang.jq -e```

 ### Import Sample Code:
 <pre>
 if [[ ! -f ~/lib/jira_lib.sh ]]; then
   echo "ERROR: Missing jira_lib.sh library"
   exit
 fi
 source ~/lib/jira_lib.sh
 </pre>

 ### Usage:
 <pre>
 # define required authentication variables
 JIRA_USER="your_username_or_email"
 JIRA_API_TOKEN="your_api_token"

 # fetch issue information for a given issue key or id
 issueKeyOrId="ISSUE-123"
 issueInfo=$(fetchJiraIssue "$issueKeyOrId")

 # check for errors in the response
 if jiraHasErrors "$issueInfo"; then
   echo "Error fetching issue information:"
   getJiraErrorMessages "$issueInfo"
 fi

 # extract specific field values from the issue information
 issueType=$(getJiraValue "$issueInfo" ".fields.issuetype.name")
 issueStatus=$(getJiraValue "$issueInfo" ".fields.status.name")


 </pre>


## Functions:
| Function | Description |
|----------|-------------|
| hasJqInstalled() |  Check if JQ is installed  <br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise <br> |
| prettyPrintJson(jsonString) |  Pretty print a JSON string using jq  <br><br><u><b>Args:</b></u><br>jsonString - the JSON string to pretty print <br><br><u><b>Output:</b></u><br>the pretty printed JSON <br> |
| jiraHasErrors(jiraContent) |  Check if the provided jira content contains error messages  <br><br><u><b>Args:</b></u><br>jiraContent - the JSON string containing the jira content <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise <br> |
| getJiraErrorMessages(jiraContent) |  Get the error messages from the provided jira content  <br><br><u><b>Args:</b></u><br>jiraContent - the JSON string containing the jira content <br><br><u><b>Output:</b></u><br>the error messages, one per line <br> |
