#!/bin/bash
#-------------------------------------------------------------------------------------------
# Parse documentation comments from bash script and generate markdown. The output file will
# be saved in the same directory unless the optional output directory option is
# specified.  The output file name will be the name of the script with '.md' extension.
# A relative path option (-r) can be used to fix the link to the script in the header.<br>
#
# @version 2023.10.13
#
# Supported Function Formats:
# - name() { }
# - function name { }
# - function name() { }
#
# Supported Keywords:
# - @param - Describes the parameters of a method.
# - @return - Describes the return code of a method. Normally 0 (success), 1 (error)
# - @output - Describes the otuput of a method, normally written to standard output so it can be captured
#
# Limitation Notes:
# - keyword descriptions are limited to single lines
#
# TODO:<br>
# - @author - Specifies the author of the class, method, or field.
# - @version - Specifies the version of the class, method, or field.
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
# # @return - 0 when true, 1 otherwise
# # @output - the text ouput
# function doWork() {
#   echo "otuput value"
#   return 0
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
PUR='\033[0;35m'
CYN='\033[1;36m'

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

# set the Internal Field Separator to newline (git-bash uses spaces for some reason)
#IFS=$'\n'

# Line regular expressions
rgxComment="^[#][^!/]([ ]*(.*))$"
rgxEmptyComment="^[#][ ]*$"
rgxHeader="^[-]{5}"
rgxKeyword="^[@]([a-zA-Z0-9_]+)[ ]([a-zA-Z0-9_$]+)?[ -]+(.+)"
rgxFunction="^(function[ ])?([a-zA-Z0-9_]+)(\(\))?[ ]?[{]"

# output path to save document file, default to current directory
OUTPUT_PATH="./"
# relative path to use with the script link
RELATIVE_PATH=""

# Print the usage information for this script to standard output.
function printHelp {
  echo "This script will parse the documentation comments from a bash script and generate"
  echo "markdown document."
  echo ""
  echo "Usage: "
  echo "  bashdoc.sh [OPTION] <file>"
  echo ""
  echo "  file - The input file to parse"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -o path   optional, directory to which the output file will be saved"
  echo "    -r path   optional, relative path to use for the script link in the header"
  echo ""
  echo "Examples:"
  echo "  bashdoc.sh script.sh"
  echo "  bashdoc.sh script1.sh script2.sh script3.sh"
  echo "  bashdoc.sh -o /output/path *.sh"
  echo "  bashdoc.sh -r "../" -o /output/path *.sh"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param $1 - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-v"
  addOption "-h"
  addOption "-o" true
  addOption "-r" true

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

  # check for output path option
  if hasArgument "-o" ]; then
    OUTPUT_PATH=$(getArgument "-o")
    log "  Output Path: $OUTPUT_PATH"
  fi

  # check for relative path for link
  if hasArgument "-r" ]; then
    RELATIVE_PATH=$(getArgument "-r")
    log "  Relative Path: $RELATIVE_PATH"
  fi
}

# Determine if text is a comment
# 
# @param $1 - text to test with regex for match
# @return - 0 (zero) when true, 1 otherwise
function isComment {
  if [[ $1 =~ $rgxComment ]]; then
    return 0
  fi
  return 1
}

# Determine if text is a completly empty comment (nothing but spaces)
#
# @param $1 - text to test with regex for match
# @return - 0 (zero) when true, 1 otherwise
function isEmptyComment {
  if [[ $1 =~ $rgxEmptyComment ]]; then
    return 0
  fi
  return 1
}

# Determine if text is a special header section indicator
# 
# @param $1 - text to test with regex for match
# @return - 0 (zero) when true, 1 otherwise
function isHeader {
  if [[ $1 =~ $rgxHeader ]]; then
    return 0
  fi
  return 1
}

# Determine if text is one a keyword
# 
# @param $1 - text to test with regex for match
# @return - 0 (zero) when true, 1 otherwise
function isKeyword {
  if [[ $1 =~ $rgxKeyword ]]; then
    return 0
  fi
  return 1
}

# Determine if text is a function
# 
# @param $1 - text to test with regex for match
# @return - 0 (zero) when true, 1 otherwise
function isFunction {
  if [[ $1 =~ $rgxFunction ]]; then
    return 0
  fi
  return 1
}

# Replace newline characters (cr and lf) to space
# 
# @param $1 - text to perform replacement
# @output - the trimmed text on standard output
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
    local commentLine=$(newLinesToSpace "${commentArr[$index]}")
    logAll "  ${GRN}Comment:${NC}${commentArr[$index]}"
    echo -n "${commentLine}" >> $outputFile
  done
}

# write out the accumulated function parameters
function writeFunctionParameters {
  local isFirstParam=true
  for index in "${!paramArr[@]}"; do 
    local paramLine="${paramArr[$index]}"
    logAll "  ${YEL}Param:${NC}${paramLine}"

    # perform keyword match to get capture groups
    if isKeyword "$paramLine"; then
      local keywordName="${BASH_REMATCH[2]}"
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
    local paramLine="${paramArr[$index]}"

    # perform keyword match to get capture groups
    if isKeyword "$paramLine"; then
      local keywordName="${BASH_REMATCH[2]}"
      local keywordDesc=$( newLinesToSpace "${BASH_REMATCH[3]}" )
      log "Keyword Name:$keywordName"
      log "Keyword Desc:$keywordDesc"
      echo -n "${keywordName} - ${keywordDesc}<br>" >> $outputFile
    fi
  done
}

# write out the output description
function writeReturnDescription {
  local keyword='return'
  if [[ ! -v keywordMap[$keyword] ]]; then
    return 0
  fi

  local description=${keywordMap[$keyword]}
  logAll "  ${PUR}Return:${NC}${description}"
  echo -n "<br><u>Return:</u><br>" >> $outputFile
  log "Keyword Desc:$description"
  echo -n "${description}<br>" >> $outputFile
}

# write out the output description
function writeOutputDescription {
  local keyword='output'
  if [[ ! -v keywordMap[$keyword] ]]; then
    return 0
  fi

  local description=${keywordMap[$keyword]}
  logAll "  ${CYN}Output:${NC}${description}"
  echo -n "<br><u>Output:</u><br>" >> $outputFile
  log "Keyword Desc:$description"
  echo -n "${description}<br>" >> $outputFile
}

# perform all the work to parse the documentation from the specified bash script file
# 
# @param $1 - the script file to parse
function parseBashScript {
  local inputFile="$1"
  
  local lineNo=0
  local lineNoPadded="000"

  # Reset the output file
  local outputFile="${OUTPUT_PATH}/${inputFile}.md"
  log "Output File: $outputFile"
  if [ -f ${outputFile} ]; then
    rm ${outputFile}
  fi
  touch ${outputFile}

  # add auto-generated comment
  echo "<small><i>Auto-generated using bashdoc.sh</i></small>" >> $outputFile

  # add file title header, check if a relative path was specified
  echo "# [${inputFile}](${RELATIVE_PATH}${inputFile})" >> $outputFile

  # declare an array to store comments before function
  local -a commentArr=()
  local -a paramArr=()
  local -A keywordMap=()
  local isFirstFunction=true


  # Read the file line by line
  while IFS= read -r line; do
    # count number of lines
    lineNo=$((++lineNo))
    
    # pad line number with spaces
    lineNoPadded=$(printf %4d $lineNo)

    # skip empty comment lines to allow for break in descriptions
    if isEmptyComment "$line"; then
      log "  BREAK"
      # add an actual blank line to comment line to array
      commentArr+=("")
      continue
    fi

    # detect if this is a comment line
    if isComment "$line"; then
      log "[$lineNoPadded] - Comment: $line"

      # get the comment text
      local commentText="${BASH_REMATCH[1]}"
      log "  Comment Text:$commentText"

      # if this is a header indicator line output as description
      if isHeader "$commentText"; then
        # write out accumulated description comments, keep the newlines
        log "Writing out comments..."
        writeComments
        echo "" >> $outputFile
      elif isKeyword "$commentText"; then
        local keywordType="${BASH_REMATCH[1]}"
        log "  Keyword Type:$keywordType"
        if [ "$keywordType" = "param" ]; then
          log "  Adding parameter to list..."
          paramArr+=("$commentText")
        else
          log " Capturing $keywordType to list..."
          #keywordMap[$keywordType]+="${commentText}"
          keywordMap[$keywordType]+="${BASH_REMATCH[3]}"
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
      local functionName="${BASH_REMATCH[2]}"

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

      log "Writing return description..."
      writeReturnDescription

      log "Writing output description..."
      writeOutputDescription

      echo " |" >> $outputFile
      
      # clear arrays for next function
      log "Clearing arrays..."
      commentArr=()
      paramArr=()
      keywordMap=()
    else
      # clear arrays when we encounter break in expected continuous comment/function
      log "Clearing arrays..."
      commentArr=()
      paramArr=()
      keywordMap=()
    fi

  done < $inputFile

}

#< - - - Main - - - >

# enable logging library escapes
escapesOn

# process arguments
processArgs "$@"

# check that the output directory exists
logAll "Output Path: $OUTPUT_PATH"
if [ ! -d "$OUTPUT_PATH" ]; then
  logAll "${RED}ERROR: output path not found${NC}"
  exit
fi

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

  parseBashScript "$inputFile"
done
