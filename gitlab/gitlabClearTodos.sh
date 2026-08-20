#!/bin/bash

#-------------------------------------------------------------------------------
# This script clears all Todo list items assigned to your GitLab account.
# 
# To use this script, you need to set the following environment variables:
# 1. GITLAB_TOKEN: Your GitLab Personal Access Token
# 2. GITLAB_API_URL: The base API URL of your GitLab instance (e.g., https://gitlab.com/api/v4)
# 
# Example: Add the following lines to your ~/.bashrc or ~/.bash_profile file
# export GITLAB_TOKEN="your_personal_access_token"
# export GITLAB_API_URL="https://gitlab.com/api/v4"
#-------------------------------------------------------------------------------

# Check if environment variables are set
if [[ -z "$GITLAB_TOKEN" ]]; then
  echo "Error: GITLAB_TOKEN is not set. Please set it in your ~/.bashrc or ~/.bash_profile file."
  exit 1
fi

if [[ -z "$GITLAB_API_URL" ]]; then
  echo "Error: GITLAB_API_URL is not set. Please set it in your ~/.bashrc or ~/.bash_profile file."
  exit 1
fi

# Function to fetch and delete todos
clear_todos() {
  # Fetch all todos assigned to the user
  echo "Fetching todos..."
  TODOS=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_API_URL/todos")

  # Check if the request was successful
  if [ $? -ne 0 ]; then
    echo "Failed to fetch todos. Please check your API token or GitLab instance URL."
    exit 1
  fi

  # Parse the JSON response and iterate over the todos
  TODO_IDS=$(echo "$TODOS" | jq -r '.[] | .id')
  
  if [ -z "$TODO_IDS" ]; then
    echo "No todos found!"
    exit 0
  fi

  # Loop through each todo ID and delete it
  for ID in $TODO_IDS; do
    echo "Deleting todo with ID: $ID..."
    DELETE_RESPONSE=$(curl -s -X DELETE --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_API_URL/todos/$ID")
    
    if [ $? -eq 0 ]; then
      echo "Todo with ID $ID deleted successfully."
    else
      echo "Failed to delete todo with ID $ID. Response: $DELETE_RESPONSE"
    fi
  done

  echo "All todos cleared!"
}

# Check for required tools
if ! command -v curl &> /dev/null || ! command -v jq &> /dev/null; then
  echo "Error: This script requires 'curl' and 'jq' to be installed."
  exit 1
fi

# Execute the function to clear todos
clear_todos