<small><i>Auto-generated using bashdoc.sh</i></small>
# [logging.sh](../logging.sh)

 Library of common debug/logging functionality.
   Debug Mode:  You can code your script with verbose console output that will 
                be displayed only if debug is enabled.
   Escapes:  Enable to use escapes option for echo command (-e)
   Prefix:  Set a prefix that will be added to every log output.
            - TIP: you can use color escape with escape mode to resume color
   LogFile:  Simple echo redirect to log file


 Import Sample Code:
     <pre>
     if [[ ! -f ~/lib/logging.sh ]]; then
       echo "ERROR: Missing logging.sh library"
       exit
     fi
     source ~/lib/logging.sh
     </pre>

 version: 2023.5.11  
 project:  https://github.com/alejandro-godinez/UsefulScripts  


## Functions:
| Function | Description |
|----------|-------------|
| debugOn() | enable debug/verbose mode   |
| debugOff() | disable debug/verbose mode   |
| setLogFile($1) | set the log file path    <br><br><u>Args:</u><br>$1 - path to log file  <br> |
| resetLogFile() | clears the current log file of content   |
| logFileOn() | enable logging to file   |
| logFileOff() | disable logging to file   |
| escapesOn() | turn on interpretation of escapes   |
| escapesOff() | turn off interpretation of escapes   |
| logPrefix($1) | set the prefix variable    <br><br><u>Args:</u><br>$1 - the prefix text  <br> |
| clearPrefix() | clear the prefix variable   |
| log($1) | Performs console output of content only if debug is on.  Writes to file when file logging is on.  Adds prefix to content if supplied.    <br><br><u>Args:</u><br>$1 - the text content to log/output  <br> |
| logN($1) | Performs console output of content with no newline only if debug is on.  Writes to file when file logging is on.  Adds prefix to content if supplied.    <br><br><u>Args:</u><br>$1 - the text content to log/output  <br> |
| logAll($1) | Performs console output of content always.  Writes to file when file logging is on.  Adds prefix to content if supplied.    <br><br><u>Args:</u><br>$1 - the text content to log/output  <br> |
| logAllN($1) | Performs console output of content always with no newline.  Writes to file when file logging is on.  Adds prefix to content if supplied.    <br><br><u>Args:</u><br>$1 - the text content to log/output  <br> |
