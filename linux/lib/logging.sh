#!/bin/bash

#//toggle debug output
DEBUG=false

#//log file path
LOGFILE=logging.log

#//toggle if log should output to file
WRITELOG=false

#//toggle if log uses -e option (escapse)
ESCAPES=false

function setLogFile {
  LOGFILE=$1
}

function resetLogFile {
  if [ -f ${LOGFILE} ]; then
    rm ${LOGFILE}
  fi
  touch ${LOGFILE}
}

#//turn on interpretation of escapes
function escapesOn {
  ESCAPES=true
}

#//turn off interpretation of escapes
function escapesOff {
  ESCAPES=true
}

function log {
  if [ "$DEBUG" = true ]; then 
    if [ "$ESCAPES" = true ]; then 
      echo -e "$1"
    else
      echo "$1"
    fi
  fi
  if [ "$WRITELOG" = true ]; then 
    echo "$( date -Iseconds ) - $1" >> ${LOGFILE}
  fi
}

#//function to console log all
function logAll {
  if [ "$ESCAPES" = true ]; then 
    echo -e "$1"
  else
    echo "$1"
  fi
  if [ "$WRITELOG" = true ]; then 
    echo "$( date -Iseconds ) - $1" >> ${LOGFILE}
  fi
}

