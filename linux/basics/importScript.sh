#!/bin/bash
#-----------------------------------------------------------------------------
#  Bash Notes: 
#    source     - executes content of specified file, in the current shell
#                 we use this to "import" that shells functions and variables.
#                 
#                 IMPORTANT: it will also execute main logic if it has any
#-----------------------------------------------------------------------------

#//source the script we want to import
#//  NOTE: arguments script has processing output
source ./arguments.sh

#//call the log function that exists in arguments.sh
log "---------------------------------------"

#//call the processArgs function from arguments.sh
processArgs "-d" "99" "one" "two" "three"

#//print the MAX_NUMBER variable which should now be 99
echo "Modifed Max Number: ${MAX_NUMBER}"
