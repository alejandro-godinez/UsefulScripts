<small><i>Auto-generated using bashdoc.sh</i></small>
# [timelog.sh](../docs/timelog.sh)

Parse time log work hour files

@version 2023.07.25

Notes:<br>
- time range without task will add time to previous task


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.  |
| processArgs($1) | Setup and execute the argument processing functionality imported from arguments.sh.  <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script <br> |
| isTaskNo($1) | Determine if text is a task number  <br><br><u>Args:</u><br>$1 - text to test with regex for match <br> |
| isTimeRange($1) | Determine if text is a time range  <br><br><u>Args:</u><br>$1 - text to test with regex for match <br> |
| getElapsedMinutes($1,$2) | Calculate the elsapsed minutes from the provided time range  <br><br><u>Args:</u><br>$1 - the start time in format (HH:mm) <br>$2 - the end time in format (HH:mm) <br> |
| div($1,$2,$3) | Perform native bash division Note: bash only works with integers, fake it using fixed point arithmetic  <br><br><u>Args:</u><br>$1 - dividend <br>$2 - divisor <br>$3 - scale (precision) <br> |
