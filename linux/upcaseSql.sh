#!/bin/bash

#-------------------------------------------------------------------------------------------
# This script will perform uppercase operation on any SQL keyword in the specified
# input file. A new copy of the script with '_ucase' in the name will be generated in the
# same directory.
# 
# @version 2024.4.26
# 
# Notes:
# - small set of keywords is currently defined, still need to add more
# 
# Usage:
# <pre>
# upcaseSql.sh [options] [files]
#   -h        This help info
#   -v        Verbose/debug output
# </pre>
# 
# Usage Examples:
# <pre>
# upcaseSql.sh myscript.sql
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
GRN='\033[0;32m'
BLU='\033[0;34m'
YEL='\033[1;33m'
PUR='\033[0;35m'
CYN='\033[1;36m'

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/spinner.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

# line bash match regex (\b not supported)
#rgxKeywordsMatch='[^:alnum:](use|declare|set|select|from|where|join|on|as|and|or|in|case|when|then|end|not|asc|desc|order|by)[^:alnum:]'

# line replace regex (\b ok with sed)
rgxKeywords='\b(use|declare|set|select|from|where|join|on|as|and|or|in|case|when|then|end|not|asc|desc|order|by)\b'

# Print the usage information for this script to standard output.
function printHelp {
  echo "This script will make all keywords in an SQL script uppercase"
  echo ""
  echo "Usage: "
  echo "  upcaseSql.sh [OPTION] <file>"
  echo ""
  echo "  file - The input file to parse"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo ""
  echo "Examples:"
  echo "  bashdoc.sh script.sh"
  echo "  bashdoc.sh script1.sh script2.sh script3.sh"
  echo "  bashdoc.sh -o /output/path *.sh"
  echo "  bashdoc.sh -r '../' -o /output/path *.sh"
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

  # printArgs
  # printRemArgs
  
  # check for help
  if hasArgument "-h"; then
    printHelp
    exit 0
  fi

  # check for vebose/debug
  if hasArgument "-v"; then
    DEBUG=true
  fi
}

# Check if a line contains an sql keyword
# 
# @param line - the line of text to test
# @return - exit value of zero indicates yes
function hasKeyword {
  local line=$1

  #log "Line:$line"
  local matchResult=$(grep -iE "$rgxKeywords" <<< "$line")
  #local cmdResult=$?

  #log "Match Result: $matchResult"
  #log "Cmd Result: $cmdResult"

  # if [[ $? -eq 0 ]]; then
  if [[ -n $matchResult ]]; then 
    return 0
  fi
  
  return 1
}

# Perform all the work to uppercase keywords in speified file
# 
# @param file - the sql script file to convert
function processFile {
  local inputFiles="$1"
 
  # get the seprate file parts name and extension
  local fileName=$(basename $inputFile)
  log "File Name: $fileName"
  local fileNameNoExt="${fileName%.*}"
  log "File Name (no ext): $fileNameNoExt"
  local fileExtension="${fileName##*.}"
  log "File Extension: $fileExtension"

  # Reset the output file
  local outputFile="${fileNameNoExt}_ucase.${fileExtension}"
  log "Output File: $outputFile"
  if [ -f ${outputFile} ]; then
    rm ${outputFile}
  fi
  touch ${outputFile}

  # Read the file line by line (-r prevent backslash escape intepretation)
  while IFS= read -r line; do
    spinChar

    if [ "$DEBUG" = true ]; then 
      spinDel
    fi

    log "LINE:$line"
    
    # perform regex on whole line
    if hasKeyword "$line"; then
      log "  ${RED}HAS KEYWORD${NC}"

      # perform keyword uppercase operation
      ucaseLine=$(echo $line | sed -E "s/$rgxKeywords/\U\1/gI")
      log "  ${GRN}UCASE:${NC}${ucaseLine}"

      # output uppercase line to file
      echo -n "${ucaseLine}" >> $outputFile
    else
      # output line to output file as is
      echo -n "$line" >> $outputFile
    fi
    
    echo "" >> $outputFile
  done < $inputFile

  spinDel
}

#< - - - Main - - - >
# @break

# enable logging library escapes
escapesOn

# process arguments
processArgs "$@"

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

# loop through all get the input file from the first argument
fileCount=0
for inputFile in "${REM_ARGS[@]}"; do
  fileCount=$((++fileCount))
  logAll "Input File ($fileCount of $argCount): ${inputFile}"

  # check if the file exists
  if [ ! -f $inputFile ]; then
    logAll "${RED}ERROR: input file not found${NC}"
    exit
  fi

  processFile "$inputFile"

  logAll "Completed: $inputFile"
done
