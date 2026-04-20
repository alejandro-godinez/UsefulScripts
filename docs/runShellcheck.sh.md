<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [runShellcheck.sh](../runShellcheck.sh)

 Script to run the shellcheck code analysis tool against all the bash script
 files in the currenty directory recursively. 
 Results for files with errors/warnings are saved in a markdown file in the
 temp directory.


 Usage:
 <pre>
 runShellcheck.sh [options]
   - h      This help info
   - v      Verbose/debug output
   - d num  Search depth (default 1)
 </pre>


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() |  print the usage information for the script to standard output  |
| processArgs(args) |  Setup and execute the argument processing functionality imported from arguments.sh.  <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script <br> |
| addHeaderToSummary(totalFiles) |  Add a header to the shellcheck summary file with information about the run  <br><br><u><b>Args:</b></u><br>totalFiles - the total number of shell script files found <br> |
| processFile(shellFile) |  Process a single shell script file with shellcheck and save the output to a file in the output directory  <br><br><u><b>Args:</b></u><br>shellFile - the path to the shell script file to process <br> |
