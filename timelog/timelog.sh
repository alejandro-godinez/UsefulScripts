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
YEL='\033[0;33m'
U_CYN='\033[4;36m'

# import logging functionality
if [[ ! -f ~/lib/logging.sh ]]; then
  echo -e "${RED}ERROR: Missing logging.sh library${NC}"
  exit
fi
source ~/lib/logging.sh

# import argument processing functionality
if [[ ! -f ~/lib/arguments.sh ]]; then
  echo -e "${RED}ERROR: Missing arguments.sh library${NC}"
  exit
fi
source ~/lib/arguments.sh

# task number regex, should support any uppercase alphanumeric with optional dash separator
rgxTaskNo="^([A-Z]+[A-Z0-9-]+)([ :\-]{2,3})?(.*)$"

# time range regex for format of "HH:mm - HH:mm"
rgxTimeRange="^([0-9]{1,2}[:][0-9]{2})[ ]-[ ]([0-9]{1,2}[:][0-9]{2})"

# define padding for task and hours output
taskPad=12
hoursPad=5
NO_TASK="NO_TASK"

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

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param $1 - array of argument values provided when calling the script
function processArgs {

  # initialize expected options
  addOption "-v"
  addOption "-h"
  
  # perform parsing of options
  parseArguments "$@"

  #printArgs
  #printRemArgs
    
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

# Perform native bash division
# Note: bash only works with integers, fake it using fixed point arithmetic
# 
# @param $1 - dividend
# @param $2 - divisor
# @param $3 - scale (precision)
function div {
  # default precision scale to 2 decimal places
  local precision=2
  local scale=100

  # check if scale parameter was specified
  if (( $# > 2 )) && [[ ! -z ${3} ]] && (( $3 >= 1)); then
    precision=$3
    scale=$((10**precision))
  fi

  # check for zero, no need to perform division just pad zeros
  if (( $1 == 0 )); then
    echo $(printf "%.${precision}f" "0")
    return
  fi
  
  # multiple by scale and perform division
  local result=$(($scale * $1 / $2))

  # insert decimal into result
  result="${result:0:-$precision}.${result: -$precision}"
  echo "${result}"
}

#< - - - Main - - - >

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

# get the input file
inputFile="${REM_ARGS[0]}"
logAll "Input File: ${inputFile}"

# check if the file does not exist
if [ ! -f "$inputFile" ]; then 
    logAll "${RED}ERROR: input file not found${NC}"
    exit
fi

# define an associative array to map taskCode key to time value
declare -A taskList

# add a position in array to accumulate time without a task
taskList["$NO_TASK"]=0

# variable to capture the task number and use for time range
currentTaskNo=""

lineNo=0
lineNoPadded="000"

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
    currentTaskNo="${BASH_REMATCH[1]}"
    log "Task: $currentTaskNo"

    # add the task number to the list of it does not exist
    if [[ ! -v taskList["$currentTaskNo"] ]]; then
      log "Adding task number to list"
      taskList["$currentTaskNo"]=0
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

    # add time without defined task to a special position
    if [[ -z ${currentTaskNo} ]]; then
      log "${RED}Error:${NC} No task for time range"
      taskList["$NO_TASK"]=$((taskList["$NO_TASK"] + elapsedMinutes))
      continue
    fi

    # add minutes to task list key position
    log "Adding $elapsedMinutes minutes to task $currentTaskNo"
    taskList["$currentTaskNo"]=$((taskList["$currentTaskNo"] + elapsedMinutes))
   
    # clear the task number after assigning this time range
    currentTaskNo=''
  fi

done < "$inputFile"

# loop through and report on accumulated task time
log "Task List:"
totalMinutes=0
for index in "${!taskList[@]}"; do
  log "  Task: $index"

  # add minutes to a total for the file
  totalMinutes=$((totalMinutes + taskList[$index]))

  # get the task minutes value
  taskMin=${taskList[$index]}
  log "    Minutes: $taskMin"

  # bash doesn't do dicimals, fake it using fixed point arithmetic (multiply by 100 to get 2 decimal positions)
  log "    Dividing by 60 to get hours"
  taskHours=$(div "$taskMin" "60")

  if [[ "$index" == "$NO_TASK" ]]; then
    logAll "${YEL}$(printf %${taskPad}s ${index}:)${NC}$(printf %${hoursPad}s ${taskHours})"
  else
    logAll "${BLU}$(printf %${taskPad}s ${index}:)${NC}$(printf %${hoursPad}s ${taskHours})"
  fi
done

log "Total Minutes: $totalMinutes"
totalHours=$(div "$totalMinutes" "60")

logAll "----------------------"
logAll "${GRN}$(printf %${taskPad}s 'Total Hours:')${NC}$(printf %${hoursPad}s ${totalHours})"
logAll ""