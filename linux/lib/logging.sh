#!/bin/bash
#-------------------------------------------------------------------------------
#  Library of common debug/logging functionality.
#    Debug Mode:  You can code your script with verbose console output that will 
#                 be displayed only if debug is enabled.
#    Escapes:  Enable to use escapes option for echo command (-e)
#    Prefix:  Set a prefix that will be added to every log output.
#             - TIP: you can use color escape with escape mode to resume color
#    LogFile:  Simple echo redirect to log file
#
#
#  Import Sample Code:
#      if [[ ! -f ~/lib/logging.sh ]]; then
#        echo "ERROR: Missing logging.sh library"
#        exit
#      fi
#      source ~/lib/logging.sh
#
#
#  version: 2023.5.5
#  project:  https://github.com/alejandro-godinez/UsefulScripts
#-------------------------------------------------------------------------------

#toggle debug output
DEBUG=false

#log file path
LOGFILE=logging.log

#toggle if log should output to file
WRITELOG=false

#toggle if log uses -e option (escapse)
ESCAPES=false

#prefix that will be applied to every log output
LOGPREFIX=""

#enable debug/verbose mode
function debugOn {
  DEBUG=true
}

# disable debug/verbose mode
function debugOff {
  DEBUG=true
}

# set the log file path
#
# @param $1 - path to log file
function setLogFile {
  LOGFILE=$1
}

# clears the current log file of content
function resetLogFile {
  if [ -f ${LOGFILE} ]; then
    rm ${LOGFILE}
  fi
  touch ${LOGFILE}
}

# enable logging to file
function logFileOn {
  LOGFILE=true
}

# disable logging to file
function logFileOff {
  LOGFILE=false
}

# turn on interpretation of escapes
function escapesOn {
  ESCAPES=true
}

# turn off interpretation of escapes
function escapesOff {
  ESCAPES=true
}

# set the prefix variable
function logPrefix {
  LOGPREFIX="$1"
}

# clear the prefix variable
function clearPrefix {
  LOGPREFIX=""
}

# Performs console output of content only if debug is on.
# Writes to file when file logging is on.
# Adds prefix to content if supplied.
# 
#
# @param $1 - the text content to log/output
function log {
  local content="$1"
  if [ ! -z "$LOGPREFIX" ]; then
    content="${LOGPREFIX}${1}"
  fi
  
  if [ "$DEBUG" = true ]; then 
    if [ "$ESCAPES" = true ]; then 
      echo -e "$content"
    else
      echo "$content"
    fi
  fi
  if [ "$WRITELOG" = true ]; then 
    echo "$( date -Iseconds ) - $content" >> ${LOGFILE}
  fi
}

# Performs console output of content always.
# Writes to file when file logging is on.
# Adds prefix to content if supplied.
# 
#
# @param $1 - the text content to log/output
function logAll {
  local content="$1"
  if [ ! -z "$LOGPREFIX" ]; then
    content="${LOGPREFIX}${1}"
  fi
  if [ "$ESCAPES" = true ]; then 
    echo -e "$content"
  else
    echo "$content"
  fi
  if [ "$WRITELOG" = true ]; then 
    echo "$( date -Iseconds ) - $content" >> ${LOGFILE}
  fi
}
