#!/bin/bash

#-------------------------------------------------------------------------------------------
# This script will perform uppercase operation on any SQL keyword/function in the specified
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

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/spinner.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  # shellcheck disable=SC1090 # disable dynamic source warning
  source "$lib"
done

# line replace regex (\b ok with sed)
rgxKeywords="\b(add|all|alter|and|any|as|asc|ascii|backup|between|by|"
rgxKeywords+="case|char|charindex|check|column|concat|constraint|create|"
rgxKeywords+="database|datalength|declare|default|delete|desc|difference|distinct|drop|"
rgxKeywords+="end|exec|exists|foreign|format|from|full|group|having|"
rgxKeywords+="in|index|inner|insert|into|is|join|"
rgxKeywords+="left|len|like|limit|lower|ltrim|nchar|not|null|"
rgxKeywords+="on|or|order|outer|patindex|primary|procedure|qoutename|"
rgxKeywords+="replace|replicate|reverse|right|right|rownum|rtrim|"
rgxKeywords+="select|set|soundex|space|str|stuff|substring|"
rgxKeywords+="then|translate|trim|unicode|upper|use|when|where)\b"


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
  local matchResult
  matchResult=$(grep -iE "$rgxKeywords" <<< "$line")
  #local cmdResult=$?

  #log "Match Result: $matchResult"
  #log "Cmd Result: $cmdResult"

  # if [[ $? -eq 0 ]]; then
  if [[ -n $matchResult ]]; then 
    return 0
  fi
  
  return 1
}

function processLine {
  local line="$1"

  # perform regex on whole line
  if hasKeyword "$line"; then

    # perform keyword uppercase operation
    ucaseLine=$(echo "$line" | sed -E "s/$rgxKeywords/\U\1/gI")

    # output uppercase line to file
    #echo -n "${ucaseLine}" >> $outputFile
    echo "${ucaseLine}"
  else
    # output line to output file as is
    echo "$line"
  fi
}

# Perform all the work to uppercase keywords in speified file
# 
# @param file - the sql script file to convert
function processFile {
  local inputFile="$1"

  # get the seprate file parts name and extension
  local fileName
  fileName=$(basename "$inputFile")
  log "File Name: $fileName"

  local fileNameNoExt
  fileNameNoExt="${fileName%.*}"
  log "File Name (no ext): $fileNameNoExt"
  
  local fileExtension
  fileExtension="${fileName##*.}"
  log "File Extension: $fileExtension"

  # Reset the output file
  local outputFile="${fileNameNoExt}_ucase.${fileExtension}"
  log "Output File: $outputFile"
  if [ -f "${outputFile}" ]; then
    rm "${outputFile}"
  fi
  touch "${outputFile}"

  # Read the file line by line (-r prevent backslash escape intepretation)
  while IFS= read -r line; do
    spinChar

    if [ "$DEBUG" = true ]; then 
      spinDel
    fi
    
    # process an individual line
    log "LINE:$line"
    newLine=$(processLine "$line")
    echo "${newLine}" >> "$outputFile"
  done < "$inputFile"

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
  if [ ! -f "$inputFile" ]; then
    logAll "${RED}ERROR: input file not found${NC}"
    exit
  fi

  processFile "$inputFile"

  logAll "Completed: $inputFile"
done
