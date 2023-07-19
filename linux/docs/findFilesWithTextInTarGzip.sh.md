<small><i>Auto-generated using bashdoc.sh</i></small>
# [findFilesWithTextInTarGzip.sh](../findFilesWithTextInTarGzip.sh)

This script will search the contents of tar gzip files
in the specified directory for entries with matching
specified search text.  


Dependencies:  
  ../UsefulScripts/linux/lib/logging.sh  

version: 2023.3.16


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Process and capture the common execution options from the arguments used when  running the script. All other arguments specific to the script are retained  in array variable.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
