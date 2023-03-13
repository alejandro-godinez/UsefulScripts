#!/bin/bash

#//toggle debug output
DEBUG=false

#//log file path
LOGFILE=logging.log

#//toggle if log should output to file
WRITELOG=false

function setLogFile {
  LOGFILE=$1
}

function resetLogFile {
  if [ -f ${LOGFILE} ]; then
    rm ${LOGFILE}
  fi
  touch ${LOGFILE}
}

function log {
  if [ "$DEBUG" = true ]; then 
    echo "$1"
  fi
  if [ "$WRITELOG" = true ]; then 
    echo "$( date -Iseconds ) - $1" >> ${LOGFILE}
  fi
}
