# logging.sh
This library bash script is a collection of common debug/logging functionality.  The intended purpose is to be able to keep all console output in a bash script but only display in debug/verbose mode.

| function | description |
|----------|-------------|
| debugOn  | Enable debug mode, all log() calls will output to standard output. |
| debugOff | Disable debug mode, only logAll() calls will output to standard output. |
| setLogFile(filePath) | Sets the log file path<br><br><u>Args:</u><br><i>path - to output log file</i> |
| resetLogFile | clears the current log file of content |
| logFileOn | enable logging to file |
| logFileOff | disable logging to file |
| escapesOn | turn on interpretation of escapes |
| escapesOff | turn off interpretation of escapes |
| logPrefix(prefix) | set the prefix variable <br><br><u>Args:</u><br><i>prefix - value that will be appended at every log call</i> |
| clearPrefix | clear the prefix variable |
| log | Performs console output of content only if debug is on. Writes to file when file logging is on. Adds prefix to content if supplied. |
| logN | Performs console output of content with no newline only if debug is on. Writes to file when file logging is on. Adds prefix to content if supplied. |
| logAll | Performs console output of content always. Writes to file when file logging is on. Adds prefix to content if supplied. |
| logAllN | Performs console output of content always. |