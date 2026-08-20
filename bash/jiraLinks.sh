#!/bin/bash
#-------------------------------------------------------------------------------
#  This script will launch each JIRA URL link found in sub directories
#  
#  version: 2023.2.2
#-------------------------------------------------------------------------------

set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

GRN='\033[0;32m'
NC='\033[0m' # No Color

DEBUG=false #//toggle debug output

function printHelp {
  echo "Usage: jiraLinks.sh [-hv]"
  echo "  Launches to browser the JIRA link found in sub direcoeis"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
}

function log {
  #echo -e "${GRN}"
  if [ "$DEBUG" = true ]; then 
    echo "$1"
  fi
  #echo -e "${NC}"
}


#-------------------------------
# Main
#-------------------------------

#//check the command arguments
for arg in "$@"
do
  log "Argument ${arg^^}"
  
  if [ "${arg^^}" = "-V" ]; then
    DEBUG=true
  fi

  if [ "${arg^^}" = "-H" ]; then
    printHelp
    exit 0
  fi
done

#find any file with jira in the name
for jiraFile in $( find -mindepth 1 -maxdepth 2 -type f -name "*jira*")
do
  log "Jira File: ${jiraFile}"

  #//get the URL values from the link file and launch it with system default browser
  url=$(grep "URL" ${jiraFile} | sed s/URL=//g)
  echo "URL: ${url}"
  
  #// launch the URL to system default browser
  start "" $url

  #//ask user to launch another URL or Quit
  read -p "Press enter for next link or 'Q' to Quit: "
  echo "Reply: ${REPLY}"
  if [ "$REPLY" = "q" ] || [ "$REPLY" = "Q" ]; then
    break
  fi
done
echo "Done"
