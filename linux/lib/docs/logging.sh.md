<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [logging.sh](../logging.sh)

 Library of common debug/logging functionality.
 - Debug Mode:  You can code your script with verbose console output that will be displayed only if debug is enabled.
 - Escapes:  Enable to use escapes option for echo command (-e)
 - Prefix:  Set a prefix that will be added to every log output.
   - TIP: you can use color escape with escape mode to resume color
 - LogFile:  Simple echo redirect to log file  
 <br>

 Import Sample Code:
 <pre>
 if [[ ! -f ~/lib/logging.sh ]]; then
   echo "ERROR: Missing logging.sh library"
   exit
 fi
 source ~/lib/logging.sh
 </pre>

 @version: 2023.5.11  


## Variables:
| Variables | Type | description |
|-----------|------|-------------|
| DEBUG | bool |  toggle debug output  |
| LOGFILE | path |  log file path  |
| WRITELOG | bool |  toggle if log should output to file  |
| ESCAPES | bool |  toggle if log uses -e option (escapse)  |
| LOGPREFIX | string |  prefix that will be applied to every log output  |
| NO_NEW_LINE | bool |  toggle if log uses -n option (no newline)  |

## Functions:
| Function | Description |
|----------|-------------|
| debugOn() |  enable debug/verbose mode  |
| debugOff() |  disable debug/verbose mode  |
| setLogFile(file) |  set the log file path  <br><br><u><b>Args:</b></u><br>file - path to log file <br> |
| resetLogFile() |  clears the current log file of content  |
| logFileOn() |  enable logging to file  |
| logFileOff() |  disable logging to file  |
| escapesOn() |  turn on interpretation of escapes  |
| escapesOff() |  turn off interpretation of escapes  |
| logPrefix(prefix) |  set the prefix variable  <br><br><u><b>Args:</b></u><br>prefix - the prefix text <br> |
| clearPrefix() |  clear the prefix variable  |
| log(content) |  Performs console output of content only if debug is on.  Writes to file when file logging is on.  Adds prefix to content if supplied.  <br><br><u><b>Args:</b></u><br>content - the text content to log/output <br> |
| logN(content) |  Performs console output of content with no newline only if debug is on.  Writes to file when file logging is on.  Adds prefix to content if supplied.  <br><br><u><b>Args:</b></u><br>content - the text content to log/output <br> |
| logAll(content) |  Performs console output of content always.  Writes to file when file logging is on.  Adds prefix to content if supplied.  <br><br><u><b>Args:</b></u><br>content - the text content to log/output <br> |
| logAllN(content) |  Performs console output of content always with no newline.  Writes to file when file logging is on.  Adds prefix to content if supplied.  <br><br><u><b>Args:</b></u><br>content - the text content to log/output <br> |
