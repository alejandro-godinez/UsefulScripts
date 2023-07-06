#!/bin/bash
#-------------------------------------------------------------------------------------------
# Parse time log work hour files
# 
# @version 2023.07.05
# 
# Notes:<br>
# - time range without task will add time to previous task
#-------------------------------------------------------------------------------------------

set -u # error on unset variable
set -e # exit on error

# echo print colors
NC='\033[0m' # No Color
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
U_CYN='\033[4;36m'       # Cyan

# import logging functionality
if [[ ! -f ~/lib/logging.sh ]]; then
  echo -e "${RED}ERROR: Missing logging.sh library${NC}"
  exit
fi
source ~/lib/logging.sh

# indexed array of arguments that are not options/flags
declare -a ARG_VALUES

# task number regex, should support any uppercase alphanumeric with optional dash separator
rgxTaskNo="^([A-Z]+[A-Z0-9-]+)([ :\-]{2,3})?(.*)$"

# time range regex for format of "HH:mm - HH:mm"
rgxTimeRange="^([0-9]{1,2}[:][0-9]{2})[ ]-[ ]([0-9]{1,2}[:][0-9]{2})"

# Print the usage information for this script to standard output.
function printHelp {
  echo "This script will parse a time log ".hrs" file and output task work time"
  echo ""
  echo "Usage: "
  echo "  timelog.sh [OPTION] <file>"
  echo ""
  echo "  file - The input file to parse"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo ""
  echo "Examples:"
  echo "  timelog.sh 2023.06.28.hrs"
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

# Determine if text is a task number
# 
# @param $1 - text to test with regex for match
function isTaskNo {
  if [[ $1 =~ $rgxTaskNo ]]; then
    return 0
  fi
  return 1
}

# Determine if text is a time range
# 
# @param $1 - text to test with regex for match
function isTimeRange {
  if [[ $1 =~ $rgxTimeRange ]]; then
    return 0
  fi
  return 1
}

# Calculate the elsapsed minutes from the provided time range
# 
# @param $1 - the start time in format (HH:mm)
# @param $2 - the end time in format (HH:mm)
function getElapsedMinutes {
  # split time into two part
  local hour="${timeStart%%:*}"
  local min="${timeStart#*:}"
  
  # calculate minutes
  local startMinute=$(( (hour * 60) + min ))
  hour="${timeEnd%%:*}"
  min="${timeEnd#*:}"
  local endMinute=$(( (hour * 60) + min ))

  # get time difference
  min=$(( endMinute - startMinute ))
  
  # return the total minutes to standard output
  echo "${min}"
}

# Perform native bash division with fixed point arithmetic
# Note: bash only works with integers, fake it using fixed point arithmetic (multiply by 100 to get 2 decimal positions)
# 
# @param $1 - dividend
# @param $2 - divisor
function div {
  local result=$((100 * $1 / $2))
  result="${result:0:-2}.${result: -2}"
  echo "${result}"
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

# get the input file
inputFile="${ARG_VALUES[0]}"
logAll "Input File: ${inputFile}"

# check if the file does not exist
if [ ! -f "$inputFile" ]; then 
    logAll "${RED}ERROR: input file not found${NC}"
    exit
fi


lineNo=0
lineNoPadded="000"

declare -A taskList
taskNo=""

# read and loop through lines
while IFS= read -r line; do
  #log "$line"

  # count number of line
  lineNo=$((++lineNo))

  # pad line number with spaces
  lineNoPadded=$(printf %4d $lineNo)

  log "[$lineNoPadded]$line"

  # detect if this is a task number line
  if isTaskNo "$line"; then

    # get the task number capture
    taskNo="${BASH_REMATCH[1]}"
    log "Task: $taskNo"

    # add the task number to the list of it does not exist
    if [[ ! -v taskList["$taskNo"] ]]; then
      log "Adding task number to list"
      taskList["$taskNo"]=0
    fi

  elif isTimeRange "$line"; then

    # get the time range parts from the capture
    timeStart="${BASH_REMATCH[1]}"
    logN "Start: $timeStart - "
    timeEnd="${BASH_REMATCH[2]}"
    logN "End: $timeEnd"

    # calculate the elapsed minutes from range
    elapsedMinutes=$(getElapsedMinutes "$timeStart" "$timeEnd")
    log " -> Minutes: $elapsedMinutes"

    # add minutes to task list key position
    log "Adding $elapsedMinutes minutes to task $taskNo"
    taskList["$taskNo"]=$((taskList["$taskNo"] + elapsedMinutes))
  fi

done < "$inputFile"

# define padding for task and hours columns
taskPad=12
hoursPad=5

log "Task List:"
totalMinutes=0
min=0
for index in "${!taskList[@]}"; do
  log "  Task: $index"

  # add minutes to a total for the file
  totalMinutes=$((totalMinutes + taskList[$index]))

  # get the task minutes value
  taskMin=${taskList[$index]}
  log "    Minutes: $taskMin"

  # bash doesn't do dicimals, fake it using fixed point arithmetic (multiply by 100 to get 2 decimal positions)
  taskHours=$(div "$taskMin" "60")

  #logAll "${BLU}${index}${NC}:${taskHours}"
  logAll "${BLU}$(printf %${taskPad}s ${index}:)${NC}$(printf %${hoursPad}s ${taskHours})"
done

log "Total Minutes: $totalMinutes"
totalHours=$(div "$totalMinutes" "60")

logAll "----------------------"
logAll "${GRN}$(printf %${taskPad}s 'Total Hours:')${NC}$(printf %${hoursPad}s ${totalHours})"