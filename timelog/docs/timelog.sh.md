<small><i>Auto-generated using bashdoc.sh</i></small>
# [timelog.sh](../timelog.sh)

Parse time log work hour files and output time spend on each task as well as total for
each file day.

@version 2023.07.25

Notes:<br>
- time range without task will add time to previous task

Usage:<br>
<pre>
timelog.sh [options] [files]
  -h           This help info
  -v           Verbose/debug output
  -s           Summary output
</pre>

Examples:
<pre>
Single:    timelog.sh 2023.06.28.hrs
Multiple:  timelog.sh 2023.06*hrs
Summary:   timelog.sh -s 2023.06*.hrs
</pre>


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
| isTaskNo($1) | Determine if text is a task number    <br><br><u>Args:</u><br>$1 - text to test with regex for match  <br> |
| isTimeRange($1) | Determine if text is a time range    <br><br><u>Args:</u><br>$1 - text to test with regex for match  <br> |
| getElapsedMinutes($1,$2) | Calculate the elsapsed minutes from the provided time range    <br><br><u>Args:</u><br>$1 - the start time in format (HH:mm)  <br>$2 - the end time in format (HH:mm)  <br> |
| div($1,$2,$3) | Perform native bash division  Note: bash only works with integers, fake it using fixed point arithmetic    <br><br><u>Args:</u><br>$1 - dividend  <br>$2 - divisor  <br>$3 - scale (precision)  <br> |
| parseFile($1) | Perform all the work to parse a single time log file    <br><br><u>Args:</u><br>$1 - the log file path  <br> |
| addTaskToSummary($1,$2) | Adds a task and time to the summary task list    <br><br><u>Args:</u><br>$1 - task number to update  <br>$2 - time to add  <br> |
| printSummary() | Print the summary of all task files parsed   |
