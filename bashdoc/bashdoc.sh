#!/bin/bash
#-------------------------------------------------------------------------------------------
# Parse documentation comments from bash script and generate markdown. The output file will
# be saved in the same directory unless the optional output directory option is
# specified.  The output file name will be the name of the script with '.md' extension.
# 
# @version 1.0.0
# 
# Supported Function Formats:
# - name() { }
# - function name { }
# - function name() { }
#
#
# Supported Keywords:<br>
# - @param - Specifies the parameters of a method.<br>
#
# Limitation Notes:
# - Comments lines cannot be empty, add a space to signal continuation of content 
#
# 
# TODO:<br>
# - @author - Specifies the author of the class, method, or field.
# - @version - Specifies the version of the class, method, or field.
# - @return - Specifies the return value of a method.
# - @see - Specifies a link to another class, method, or field.
# 
# Sample:
# <pre>
# #!/bin/bash
# #-------------------------------------------
# # This is the script description section
# #-------------------------------------------
# 
# # This function does work
# # @param $1 - the first parameter
# function doWork() {
# }
#
# </pre>
#-------------------------------------------------------------------------------------------

set -u # error on unset variable
set -e # exit on error

# echo print colors
NC='\033[0m' # No Color
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
YEL='\033[1;33m'

# import logging functionality
if [[ ! -f ~/lib/logging.sh ]]; then
  echo -e "${RED}ERROR: Missing logging.sh library${NC}"
  exit
fi
source ~/lib/logging.sh

# set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

# indexed array of arguments that are not options/flags
declare -a ARG_VALUES

# Line regular expressions
rgxComment="^[#][^!/]([ ]*(.*))$"
rgxHeader="^[-]{5}"
rgxKeyword="^[@]([a-zA-Z0-9_]+)[ ]([a-zA-Z0-9_$]+)[ -]+(.+)"
rgxFunction="^(function[ ])?([a-zA-Z0-9_]+)(\(\))?[ ]?[{]"


# Print the usage information for this script to standard output.
function printHelp {
  echo "This script will parse the documentation comments from a bash script and generate"
  echo "markdown document."
  echo ""
  echo "Usage: "
  echo "  bashdoc.sh [OPTION] <file> [outputDir]"
  echo ""
  echo "  file - The input file to parse"
  echo "  outputDir - optional, directory to which the output file will be saved"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo ""
}

# Process and capture the common execution options from the arguments used when
# running the script. All other arguments specific to the script are retained
# in array variable.
# 
# @param $1 - array of argument values provided when calling the script
function processArgs {
  # check the command arguments
  log "Arg Count: $#"
  while (( $# > 0 )); do
    arg=$1
    log "  Argument: ${arg}"
    
    # the arguments to the next item
    shift 
    
    # check for verbose
    if [ "${arg^^}" = "-V" ]; then
      DEBUG=true
      continue
    fi
    
    # check for help
    if [ "${arg^^}" = "-H" ]; then
      printHelp
      exit 0
    fi
    
    # keep arguments that are not options or values from the option
    log "    > Adding $arg to rem arg list"
    ARG_VALUES+=("$arg")
  done
}

# Determine if text is a comment
#
# @param $1 - text to test with regex for match
function isComment {
  if [[ $1 =~ $rgxComment ]]; then
    return 0
  fi
  return 1
}

# Determine if text is a special header section indicator
#
# @param $1 - text to test with regex for match
function isHeader {
  if [[ $1 =~ $rgxHeader ]]; then
    return 0
  fi
  return 1
}

# Determine if text is one a keyword
#
# @param $1 - text to test with regex for match
function isKeyword {
  if [[ $1 =~ $rgxKeyword ]]; then
    return 0
  fi
  return 1
}

# Determine if text is a function
#
# @param $1 - text to test with regex for match
function isFunction {
  if [[ $1 =~ $rgxFunction ]]; then
    return 0
  fi
  return 1
}

# Replace newline characters (cr and lf) to space
#
# @param $1 - text to perform replacement
function newLinesToSpace() {
  echo "$1" | tr "\r\n" " "
}

# Write the accumulated comments to the output file
function writeComments {
  log "  Comment Count: ${#commentArr[@]}"
  for index in "${!commentArr[@]}"; do
    echo "${commentArr[$index]}" >> $outputFile
  done
}

# Write the accumulated comments to the output file trimmed of any newline
function writeCommentsFlat {
  log "  Comment Count: ${#commentArr[@]}"
  for index in "${!commentArr[@]}"; do 
    commentLine=$(newLinesToSpace "${commentArr[$index]}")
    logAll "${GRN}Comment:${NC}${commentArr[$index]}"
    echo -n "${commentLine}" >> $outputFile
  done
}

# write out the accumulated function parameters
function writeFunctionParameters {
  local isFirstParam=true
  for index in "${!paramArr[@]}"; do 
    paramLine="${paramArr[$index]}"
    logAll "${YEL}Param:${NC}${paramLine}"

    # perform keyword match to get capture groups
    if isKeyword "$paramLine"; then
      keywordName="${BASH_REMATCH[2]}"
      log "Keyword Name:$keywordName"

      log "IsFirstParam:$isFirstParam"
      if [ "$isFirstParam" = false ]; then
        echo -n "," >> $outputFile
      fi
      isFirstParam=false
      echo -n "${keywordName}" >> $outputFile
    fi
  done
}

# write out the paramaters formatted for description in table
function writeParameterDescription {
  local paramCount=${#paramArr[@]}
  if (( paramCount > 0 )); then
    echo -n "<br><br><u>Args:</u><br>" >> $outputFile
  else
    return 0
  fi

  for index in "${!paramArr[@]}"; do 
    paramLine="${paramArr[$index]}"

    # perform keyword match to get capture groups
    if isKeyword "$paramLine"; then
      keywordName="${BASH_REMATCH[2]}"
      keywordDesc=$( newLinesToSpace "${BASH_REMATCH[3]}" )
      log "Keyword Name:$keywordName"
      log "Keyword Desc:$keywordDesc"
      echo -n "${keywordName} - ${keywordDesc}<br>" >> $outputFile
    fi
  done
}

#< - - - Main - - - >

# enable logging library escapes
escapesOn

# process arguments
processArgs "$@"

# print out the list of args that were not consumed by function (non-flag arguments)
argCount=0
if [[ -v ARG_VALUES ]]; then
  argCount=${#ARG_VALUES[@]}
  log "List Remaining Args: ${argCount}"
  for item in "${ARG_VALUES[@]}"; do log "  ${item}"; done
else
  #log "No Process Arguments Identified"
  printHelp
  exit 0
fi

# get the input file from the first argument
inputFile="${ARG_VALUES[0]}"
logAll "Input File: ${inputFile}"

# check if the file exists
if [[ -e inputFile ]]; then
  logAll "${RED}ERROR: input file not found${NC}"
  exit
fi

# check if output path was specified
outputPath=""
if (( argCount > 1)); then
  outputPath="${ARG_VALUES[1]}"
  logAll "Output Path: $outputPath"
  if [ ! -d "$outputPath" ]; then
    logAll "${RED}ERROR: output path not found${NC}"
    exit
  fi
fi

lineNo=0
lineNoPadded="000"

# Reset the output file
outputFile="${outputPath}/${inputFile}.md"
log "Output File: $outputFile"
if [ -f ${outputFile} ]; then
  rm ${outputFile}
fi
touch ${outputFile}

# add auto-generated comment
echo "<!-- Auto-generated using bashdoc.sh -->" >> $outputFile

# add file title header
echo "# [${inputFile}](${inputFile})" >> $outputFile

# declare an array to store comments before function
declare -a commentArr=()
declare -a paramArr=()
isFirstFunction=true


# Read the file line by line
while IFS= read -r line; do
  # count number of lines
  lineNo=$((++lineNo))
  
  # pad line number with spaces
  lineNoPadded=$(printf %4d $lineNo)

  # detect if this is a comment line
  if isComment "$line"; then
    log "[$lineNoPadded] - Comment: $line"

    # get the comment text
    commentText="${BASH_REMATCH[1]}"
    log "  Comment Text:$commentText"

    # if this is a header indicator line output as description
    if isHeader "$commentText"; then
      # write out accumulated description comments, keep the newlines
      log "Writing out comments..."
      writeComments
      echo "" >> $outputFile

    elif isKeyword "$commentText"; then
      keywordType="${BASH_REMATCH[1]}"
      log "  Keyword Type:$keywordType"
      if [ "$keywordType" = "param" ]; then
        log "  Adding parameter to list..."
        paramArr+=("$commentText")
      fi
    else
      # add comment line to array
      log "  Adding comment to list..."
      commentArr+=("$commentText")
    fi

  elif isFunction "$line"; then

    # add function header when first function is encountered
    if [ "$isFirstFunction" = true ]; then 
      echo "" >> $outputFile
      echo "## Functions:" >> $outputFile
      echo "| Function | Description |" >> $outputFile
      echo "|----------|-------------|" >> $outputFile
      isFirstFunction=false
    fi

    # get the function name from first group capture
    functionName="${BASH_REMATCH[2]}"

    # write function with open parenthesis
    logAll "${BLU}Function:${NC}${functionName}"
    echo -n "| ${functionName}(" >> $outputFile

    # write out the parameters if any
    log "Writing function parameters..."
    writeFunctionParameters

    # close the function
    echo -n ") | " >> $outputFile

    # write out the accumulated comments
    log "Writing comments flat..."
    writeCommentsFlat

    log "Writing parameter descriptions..."
    writeParameterDescription

    echo " |" >> $outputFile
    
    # clear arrays for next function
    log "Clearing arrays..."
    commentArr=()
    paramArr=()
  else
    # clear arrays when we encounter break in expected continuous comment/function
    log "Clearing arrays..."
    commentArr=()
    paramArr=()
  fi

done < $inputFile

