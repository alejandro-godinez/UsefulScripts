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
#      <pre>
#      if [[ ! -f ~/lib/logging.sh ]]; then
#        echo "ERROR: Missing logging.sh library"
#        exit
#      fi
#      source ~/lib/logging.sh
#      </pre>
# 
#  version: 2023.5.11  
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

#toggle if log uses -n option (no newline)
NO_NEW_LINE=false

# enable debug/verbose mode
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
  WRITELOG=true
}

# disable logging to file
function logFileOff {
  WRITELOG=false
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
# 
# @param $1 - the prefix text
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
# @param $1 - the text content to log/output
function log {
  local content="$1"
  if [ ! -z "$LOGPREFIX" ]; then
    content="${LOGPREFIX}${1}"
  fi
  
  if [ "$DEBUG" = true ]; then 
    logAll "$1"
  else 
    if [ "$WRITELOG" = true ]; then 
      if [ "$NO_NEW_LINE" = true ]; then
        echo -n "$( date -Iseconds ) - $content" >> ${LOGFILE}
      else
        echo "$( date -Iseconds ) - $content" >> ${LOGFILE}
      fi
    fi
  fi
}

# Performs console output of content with no newline only if debug is on.
# Writes to file when file logging is on.
# Adds prefix to content if supplied.
# 
# @param $1 - the text content to log/output
function logN {
  NO_NEW_LINE=true
  
  log "$1"
  
  NO_NEW_LINE=false
}

# Performs console output of content always.
# Writes to file when file logging is on.
# Adds prefix to content if supplied.
# 
# @param $1 - the text content to log/output
function logAll {
  local content="$1"
  if [ ! -z "$LOGPREFIX" ]; then
    content="${LOGPREFIX}${1}"
  fi
  if [ "$ESCAPES" = true ]; then
    if [ "$NO_NEW_LINE" = true ]; then
      echo -e -n "$content"
    else
      echo -e "$content"
    fi
  else
    if [ "$NO_NEW_LINE" = true ]; then
      echo -n "$content"
    else
      echo "$content"
    fi
  fi
  if [ "$WRITELOG" = true ]; then 
    if [ "$NO_NEW_LINE" = true ]; then
      echo -n "$( date -Iseconds ) - $content" >> ${LOGFILE}
    else
      echo "$( date -Iseconds ) - $content" >> ${LOGFILE}
    fi
  fi
}

# Performs console output of content always with no newline.
# Writes to file when file logging is on.
# Adds prefix to content if supplied.
# 
# @param $1 - the text content to log/output
function logAllN {
  NO_NEW_LINE=true
  
  logAll "$1"
  
  NO_NEW_LINE=false
}