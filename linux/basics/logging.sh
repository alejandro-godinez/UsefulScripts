#!/bin/bash

#-----------------------------------------------------------------------------
#  Bash Notes: 
#    function   - keyword optional for readability in bash, for POSIX use
#                 use parenthesis syntax instead "myfunc(){ }"
#    date -I    - date with ISO8601 format value
#-----------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//toggle debug output
DEBUG=true
LOGFILE=logging.log
WRITELOG=true

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

#resetLogFile

log "One"
sleep .5  # Waits half seconds.
log "Two"
sleep 2  # Waits 2 seconds.
log "Three"