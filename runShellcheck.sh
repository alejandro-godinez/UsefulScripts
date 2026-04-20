#!/bin/bash
#----------------------------------------------------------------------------
# Script to run the shellcheck code analysis tool against all the bash script
# files in the currenty directory recursively. 
# Results for files with errors/warnings are saved in a markdown file in the
# temp directory.
# 
# @version 2026.04.19
# 
# Usage:
# <pre>
# runShellcheck.sh [options]
#   - h      This help info
#   - v      Verbose/debug output
#   - d num  Search depth (default 1)
# </pre>
#----------------------------------------------------------------------------

# set the bash set variables
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
U_CYN='\033[4;36m' # Underline Cyan

# check if shellcheck is installed
if ! command -v shellcheck &> /dev/null; then
  echo -e "${RED}ERROR: shellcheck is not installed. Please install it and try again.${NC}"
  exit 1
fi

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh ~/lib/spinner.sh )
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi
  # shellcheck disable=SC1090 # disable warning for dynamic source
  source "$lib"
done

# output path to save shell check results
OUTPUT_PATH="./temp/"
SUMMARY_FILE="${OUTPUT_PATH}shellcheck_summary.md"

#//search depth
MAX_DEPTH=1

#//numeric regex
RGX_NUM='^[0-9]+$'

# print the usage information for the script to standard output
function printHelp {
  echo "Script to run shellchec1k tool against all the bash script file in the currenty"
  echo "directory recursively and save the results in a specified output directory."
  echo ""
  echo "Usage:"
  echo "runShellcheck.sh [options]"
  echo "  - h      Thsis help info"
  echo "  - v      Verbose/debug output"
  echo "  - d num  Search depth (default 1)"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param args - array of argument values provided when calling the script
function processArgs {
  # initialize expected options
  addOption "-v"
  addOption "-h"
  addOption "-d" true

  # perform parsing of the arguments
  parseArguments "$@"

  # printArgs
  # printRemArgs

  # check for help
  if hasArgument "-h"; then
    printHelp
    exit 0
  fi

  if hasArgument "-v"; then
    # shellcheck disable=SC2034 # disable warning for unused variable, DEBUG is sourced from logging.sh
    DEBUG=true
  fi

  # check for depth
  if hasArgument "-d"; then
    numValue=$(getArgument "-d")
    log "  Depth Value: $numValue"
    if [[ $numValue =~ $RGX_NUM ]]; then
      MAX_DEPTH=$numValue
      log "  Max Depth: $MAX_DEPTH"
    fi
  fi
}

# Add a header to the shellcheck summary file with information about the run
# 
# @param totalFiles - the total number of shell script files found
function addHeaderToSummary {
  local totalFiles=$1
  {
    echo "# Shellcheck Summary  "
    echo "**Generated on:** $(date)  "
    echo "**Working Directory:** $(pwd)  "
    echo "**Search Depth:** ${MAX_DEPTH}  "
    echo "**Total Files Found:** ${totalFiles}  "
    echo "  "
    echo "---"
    echo "  "
  } >> "$SUMMARY_FILE"
}

# Process a single shell script file with shellcheck and save the output to a file in the output directory
# 
# @param shellFile - the path to the shell script file to process
function processFile {
  local shellFile=$1
  
  # local fileName
  # fileName=$(basename "$shellFile")

  # Capture shellcheck output without failing the script on non-zero status
  local output
  output=$(shellcheck "$shellFile" 2>&1 || true)

  #determine if output is empty or not
  if [[ -z "$output" ]]; then
    log "No issues found by shellcheck for $shellFile"
    return 1
  fi  

  # create a relative path that is two levels up from the output directory
  local relativePath
  relativePath="../${shellFile#./}"
  log "Relative Path: $relativePath"

  # Add a summary entry only for files that generated output
  {
    echo "[$shellFile]($relativePath)"
    echo "<pre>"
    echo "$output"
    echo "</pre>"
    echo
  } >> "$SUMMARY_FILE"

  returnn 0 # indicate that output was generated
}

#< - - - Main - - - >
# @break

# enable logging library escapes
escapesOn

# process arguments
processArgs "$@"

# check that the output directory exists
logAll "Output Path: $OUTPUT_PATH"
if [[ ! -d "$OUTPUT_PATH" ]]; then
  log "Creating the output directory"
  mkdir "$OUTPUT_PATH"

  if [ ! -d "$OUTPUT_PATH" ]; then
    logAll "${RED}ERROR: output path not found${NC}"
    exit
  fi
fi

# initialize the shellcheck summary file
echo "" > "$SUMMARY_FILE"

# find all the .sh file recursively and store them in an array
logAll "Finding all shell script files..."
logAll "Depth Search: $MAX_DEPTH"
declare -a fileList=()
mapfile -t fileList < <(find . -mindepth 1 -maxdepth "$MAX_DEPTH" -type f -name "*.sh")

# get a count of the number of files found
totalFiles=${#fileList[@]}
logAll "Number of shell script files found: $totalFiles"

# append a header to the summary file
log "Adding header to summary file..."
addHeaderToSummary "$totalFiles"

# loop through the array and run shellcheck on each file
fileCount=0
filesWithErrors=0
filesWithoutErrors=0

for file in "${fileList[@]}"; do
  fileCount=$((++fileCount))
  logAll "Processing File ($fileCount of $totalFiles): ${U_CYN}$file${NC}"
  spinChar

  if processFile "$file"; then
    filesWithErrors=$((++filesWithErrors))
  else
    filesWithoutErrors=$((++filesWithoutErrors))
  fi

  spinDel
done
{
  echo "## Results  "
  echo "**Files with Issues:** $filesWithErrors  "
  echo "**Files without Issues:** $filesWithoutErrors  "
} >> "$SUMMARY_FILE"

logAll "Shellcheck processing complete. Summary saved to $SUMMARY_FILE"