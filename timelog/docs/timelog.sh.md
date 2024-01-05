<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [timelog.sh](../timelog.sh)

Parse time log work hour files and output time spend on each task as well as total for
each file day.

@version 2023.11.15

Notes:<br>
- time range without task will accumulated to a special 'NO_TASK' entry

Usage:<br>
<pre>
timelog.sh [options] [files]
  -h           This help info
  -v           Verbose/debug output
  -s           Summary output
  -t           Task filter
  -c           Generate CSV File
</pre>

Examples:
<pre>
All .hrs Files:  timelog.sh -s
Single:          timelog.sh 2023.06.28.hrs
Multiple:        timelog.sh 2023.06*hrs
                 timelog.sh $(find -type f -name 202401*.hrs)
Summary:         timelog.sh -s 2023.06*.hrs
Task Filter:     timelog.sh -t "ABC-1234"
</pre>


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs(args) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
| isTaskNo(text) | Determine if text is a task number    <br><br><u><b>Args:</b></u><br>text - text to test with regex for match  <br><br><u><b>Return:</b></u><br>0 when true, 1 otherwise  <br> |
| isTimeRange(text) | Determine if text is a time range    <br><br><u><b>Args:</b></u><br>text - text to test with regex for match  <br><br><u><b>Return:</b></u><br>0 when true, 1 otherwise  <br> |
| getElapsedMinutes(end,&nbsp;start) | Calculate the elsapsed minutes from the provided time range    <br><br><u><b>Args:</b></u><br>end - the end time in format (HH:mm)  <br>start - the start time in format (HH:mm)  <br><br><u><b>Output:</b></u><br>elapsed minutes written to standard output  <br> |
| div(dividend,&nbsp;precision,&nbsp;divisor) | Perform native bash division  Note: bash only works with integers, fake it using fixed point arithmetic    <br><br><u><b>Args:</b></u><br>dividend - number being divided  <br>precision - decimal precision (scale factor), defaults to 2  <br>divisor - number to divide by  <br><br><u><b>Output:</b></u><br>result of division, written to standard output  <br> |
| getDateTimeFileName() | Gets a date time string ("date_time") to use in file names   <br><u><b>Return:</b></u><br>0 when true, 1 otherwise  <br><br><u><b>Output:</b></u><br>date time string written to standard output  <br> |
| writeToCSV(minutes,&nbsp;taskNo,&nbsp;inputFile) | Write values to this run's output csv file   <br><br><u><b>Args:</b></u><br>minutes - the work minutes  <br>taskNo - the task number  <br>inputFile - the file that was parsed for the values  <br> |
| trimNewLines(text) | Trim newline characters (cr and lf)    <br><br><u><b>Args:</b></u><br>text - text to perform trim  <br><br><u><b>Output:</b></u><br>the trimmed text on standard output  <br> |
| parseFile(inputFile) | Perform all the work to parse a single time log file    <br><br><u><b>Args:</b></u><br>inputFile - the log file path  <br> |
| addTaskToSummary(taskNo,&nbsp;time) | Adds a task and time to the summary task list    <br><br><u><b>Args:</b></u><br>taskNo - task number to update  <br>time - time to add in minutes  <br> |
| printSummary() | Print the summary of all task files parsed   |
