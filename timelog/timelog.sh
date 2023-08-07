#!/bin/bash
#-------------------------------------------------------------------------------------------
# Parse time log work hour files and output time spend on each task as well as total for
# each file day.
# 
# @version 2023.08.07
# 
# Notes:<br>
# - time range without task will add time to previous task
# 
# Usage:<br>
# <pre>
# timelog.sh [options] [files]
#   -h           This help info
#   -v           Verbose/debug output
#   -s           Summary output
#   -t           Task filter
# </pre>
# 
# Examples:
# <pre>
# All .hrs Files:  timelog.sh -s
# Single:          timelog.sh 2023.06.28.hrs
# Multiple:        timelog.sh 2023.06*hrs
# Summary:         timelog.sh -s 2023.06*.hrs
# Task Filter:     timelog.sh -t "ABC-1234"
# </pre>
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

SPINNER=("|" "/" "-" "\\")
SPIN_IDX=0

# define list of libraries and import them
declare -a libs=( ~/lib/logging.sh ~/lib/arguments.sh)
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

# task number regex, should support any uppercase alphanumeric with optional dash separator
rgxTaskNo="^([A-Z]+[A-Z0-9-]+)([ :\-]{2,3})?(.*)$"

# time range regex for format of "HH:mm - HH:mm"
rgxTimeRange="^([0-9]{1,2}[:][0-9]{2})[ ]-[ ]([0-9]{1,2}[:][0-9]{2})"

# define padding for task and hours output
TASK_PAD=12
HOURS_PAD=5
NO_TASK="NO_TASK"

# summary of hours for all files parsed
declare -A summaryTaskList

# Display the next step in the cursor spinner
function spinCursor {
  # increment spin counter
  SPIN_IDX=$((++SPIN_IDX))

  # reset spinner back to zero
  if (( SPIN_IDX > 3)); then
    SPIN_IDX=0
  fi

  # print backspace to remove previous character and next spin character
  echo -en "\b${SPINNER[$SPIN_IDX]}"
}

# Print the usage information for this script to standard output.
function printHelp {
  echo "This script will parse a time log ".hrs" file and output task work time"
  echo ""
  echo "Usage: "
  echo "  timelog.sh [OPTION] <files>"
  echo ""
  echo "  file - The input file to parse"
  echo ""
  echo "  Options:"
  echo "    -h        This help text info"
  echo "    -v        Verbose/debug output"
  echo "    -s        Summary output"
  echo "    -t        Task filter"
  echo ""
  echo "Examples:"
  echo "  All .hrs Files:  timelog.sh -s"
  echo "  Single:          timelog.sh 2023.06.28.hrs"
  echo "  Multiple:        timelog.sh 2023.06*hrs"
  echo "  Summary:         timelog.sh -s 2023.06*.hrs"
}

# Setup and execute the argument processing functionality imported from arguments.sh.
# 
# @param $1 - array of argument values provided when calling the script
function processArgs {

  # initialize expected options
  addOption "-v"
  addOption "-h"
  addOption "-s"
  addOption "-t" true
  
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

# Perform all the work to parse a single time log file
# 
# @param $1 - the log file path
function parseFile {
  local inputFile=$1

  # define an associative array to map taskCode key to time value
  local -A taskList

  # add a position in array to accumulate time without a task
  # taskList["$NO_TASK"]=0

  # variable to capture the task number and use for time range
  local currentTaskNo=""

  local lineNo=0
  local lineNoPadded="000"

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

      # filter for only the specified task
      if hasArgument "-t"; then
        local filterTask=$(getArgument "-t")
        if [ "$currentTaskNo" != "$filterTask" ]; then
          currentTaskNo=""
          continue
        fi
      fi

      # add the task number to the list of it does not exist
      if [[ ! -v taskList["$currentTaskNo"] ]]; then
        log "Adding task number to list"
        taskList["$currentTaskNo"]=0
      fi

    elif isTimeRange "$line"; then

      # get the time range parts from the capture
      local timeStart="${BASH_REMATCH[1]}"
      logN "Start: $timeStart - "
      local timeEnd="${BASH_REMATCH[2]}"
      logN "End: $timeEnd"

      # calculate the elapsed minutes from range
      local elapsedMinutes=$(getElapsedMinutes "$timeStart" "$timeEnd")
      log " -> Minutes: $elapsedMinutes"

      # add time without defined task to a special position
      if [[ -z ${currentTaskNo} ]]; then

        # when task filter has been specified don't add the NO_TASK entries
        if hasArgument "-t"; then
          continue
        fi

        # add the special NO_TASK entry if it does not exist
        if [[ ! -v taskList["$NO_TASK"] ]]; then
          taskList["$NO_TASK"]=0
        fi

        log "${RED}Error:${NC} No task for time range"
        taskList["$NO_TASK"]=$((taskList["$NO_TASK"] + elapsedMinutes))

        # add task time to summary
        addTaskToSummary "$NO_TASK" $elapsedMinutes
        continue
      fi

      # add minutes to task list key position
      log "Adding $elapsedMinutes minutes to task $currentTaskNo"
      taskList["$currentTaskNo"]=$((taskList["$currentTaskNo"] + elapsedMinutes))
      
      # add task time to summary
      addTaskToSummary "$currentTaskNo" $elapsedMinutes
    
      # clear the task number after assigning this time range
      currentTaskNo=''
    fi

  done < "$inputFile"

  # don't print individual file info when summary option was specified
  if hasArgument "-s"; then
    return
  fi

  logAllN "\b"
  logAll "File: ${inputFile}"

  # loop through and report on accumulated task time
  log "Task List:"
  local totalMinutes=0
  for index in "${!taskList[@]}"; do
    log "  Task: $index"

    # add minutes to a total for the file
    totalMinutes=$((totalMinutes + taskList[$index]))

    # get the task minutes value
    local taskMin=${taskList[$index]}
    log "    Minutes: $taskMin"

    # bash doesn't do dicimals, fake it using fixed point arithmetic (multiply by 100 to get 2 decimal positions)
    log "    Dividing by 60 to get hours"
    local taskHours=$(div "$taskMin" "60")

    if [[ "$index" == "$NO_TASK" ]]; then
      logAll "${YEL}$(printf %${TASK_PAD}s ${index}:)${NC}$(printf %${HOURS_PAD}s ${taskHours})"
    else
      logAll "${BLU}$(printf %${TASK_PAD}s ${index}:)${NC}$(printf %${HOURS_PAD}s ${taskHours})"
    fi
  done

  # don't print individual file total when task filter has been specified 
  if hasArgument "-t"; then
    return
  fi

  log "Total Minutes: $totalMinutes"
  local totalHours=$(div "$totalMinutes" "60")

  logAll "----------------------"
  logAll "${GRN}$(printf %${TASK_PAD}s 'Total Hours:')${NC}$(printf %${HOURS_PAD}s ${totalHours})"
  logAll ""
}

# Adds a task and time to the summary task list
# 
# @param $1 - task number to update
# @param $2 - time to add
function addTaskToSummary {
  local taskNo="$1"
  local elapsedMinutes=$2

  if [[ ! -v summaryTaskList["$taskNo"] ]]; then
    log "Adding task number ($taskNo) to summary list"
    summaryTaskList["$taskNo"]=0
  fi
  summaryTaskList["$taskNo"]=$((summaryTaskList["$taskNo"] + elapsedMinutes))
}

# Print the summary of all task files parsed
function printSummary {
  for index in "${!summaryTaskList[@]}"; do
    log "  Task: $index"

    # get the task minutes value
    local taskMin=${summaryTaskList[$index]}
    log "    Minutes: $taskMin"
    
    # bash doesn't do dicimals, fake it using fixed point arithmetic (multiply by 100 to get 2 decimal positions)
    log "    Dividing by 60 to get hours"
    local taskHours=$(div "$taskMin" "60")

    if [[ "$index" == "$NO_TASK" ]]; then
      logAll "${YEL}$(printf %${TASK_PAD}s ${index}:)${NC}$(printf %${HOURS_PAD}s ${taskHours})"
    else
      logAll "${BLU}$(printf %${TASK_PAD}s ${index}:)${NC}$(printf %${HOURS_PAD}s ${taskHours})"
    fi
  done
}

#< - - - Main - - - >

# enable logging library escapes
escapesOn

# process arguments
processArgs "$@"

# check if no files were specified, no remaining arguments 
argCount=0
if [[ -v REM_ARGS ]]; then
  argCount=${#REM_ARGS[@]}
else
  # search for hrs files in current directory, depth of 3 should be enough (timelog/year/month)
  log "Serach for hrs files..."
  fileList=$(find -mindepth 1 -maxdepth 3 -type f -name '*.hrs')
  for file in $fileList; do
    REM_ARGS+=($file)
    argCount=$((++argCount))
  done
fi

# check files were specified or found
if (( argCount == 0 )); then
  logAll "No files found"
  exit 0
fi

log "List Found Files: ${argCount}"
for item in "${REM_ARGS[@]}"; do log "  ${item}"; done

# loop through all the input files from the arguments
fileCount=0
for inputFile in "${REM_ARGS[@]}"; do
  fileCount=$((++fileCount))
  log "Input File ($fileCount of $argCount): ${inputFile}"
  
  # print a dot indicator that work is being done
  if ! hasArgument "-v"; then
    spinCursor
  fi

  # check if the file exists
  if [ ! -f "${inputFile}" ]; then
    logAll "${RED}ERROR: input file not found${NC}"
    continue
  fi

  # don't parse file if task filter was specified and file doesn't contain the task
  if hasArgument "-t"; then
    filterTask=$(getArgument "-t")
    log "Filter: $filterTask"
    if ! grep -q -m 1 -c "$filterTask" "$inputFile"; then
      log "  Task Filter Not found"
      continue
    fi
  fi

  log "Parsing File..."
  parseFile $inputFile
done

# check for the print summary option
if hasArgument "-s"; then
  log "Printing Summary..."
  printSummary
fi