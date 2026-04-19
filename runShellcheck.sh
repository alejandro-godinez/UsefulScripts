#!/bin/bash
#----------------------------------------------------------------------------
# Script to run shellcheck tool against all the bash script file in the currenty
# directory recursively and save the results in a specified output directory.
# 
# @version 2026.04.19
# 
# Usage:
# runShellcheck.sh [options]
#   - h      This help info
#   - v      Verbose/debug output
#   - d num  Search depth (default 1)
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
OUTPUT_PATH="./temp/shellcheck/"

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
  echo "  - h    Thsis help info"
  echo "  - v    Verbose/debug output"
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
    # shellcheck disable=SC2034 # disable warning for unused variable
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
    echo "--------------------------------------------"
    echo "Shellcheck Summary"
    echo "Generated on: $(date)"
    echo "Working Directory: $(pwd)"
    echo "Search Depth: $MAX_DEPTH"
    echo "Total Files Found: $totalFiles"
    echo "--------------------------------------------"
    echo
  } >> "$SUMMARY_FILE"
}

# Process a single shell script file with shellcheck and save the output to a file in the output directory
# 
# @param shellFile - the path to the shell script file to process
function processFile {
  local shellFile=$1
  
  # Capture shellcheck output without failing the script on non-zero status
  local output
  output=$(shellcheck "$shellFile" 2>&1 || true)

  #determine if output is empty or not
  if [[ -z "$output" ]]; then
    log "No issues found by shellcheck for $shellFile"
    return 
  fi

  # Determine output file path, preserving relative subdirectory
  local relative_path
  relative_path="${shellFile#./}"
  local output_file
  output_file="${OUTPUT_PATH}${relative_path}.txt"
  log "Output File: $output_file"
  
  local output_dir
  output_dir=$(dirname "$output_file")
  
  # Create the subdirectory if it doesn't exist
  log "Creating output directory..."
  log "Output Directory: $output_dir"
  mkdir -p "$output_dir"
  
  # Save the output to the file
  echo "$output" > "$output_file"

  # Add a summary entry only for files that generated output
  file_name=$(basename "$shellFile")
  {
    echo "$file_name"
    echo "$shellFile"
    echo "$output_file"
    echo
  } >> "$SUMMARY_FILE"
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
SUMMARY_FILE="${OUTPUT_PATH}shellcheck_summary.txt"
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
for file in "${fileList[@]}"; do
  fileCount=$((++fileCount))
  logAll "Processing File ($fileCount of $totalFiles): ${U_CYN}$file${NC}"
  spinChar
  processFile "$file"
  spinDel
done

logAll "Shellcheck processing complete. Summary saved to $SUMMARY_FILE"