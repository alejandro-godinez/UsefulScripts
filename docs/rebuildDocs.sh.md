<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [rebuildDocs.sh](../rebuildDocs.sh)

Convenience script to re-build all bash documentation files in this project using bashdoc

@version 2023.12.14

Usage:
<pre>
rebuildDocs.sh [options]
  -h        This help info
  -v        Verbose/debug output
</pre>


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.  |
| processArgs(args) | Setup and execute the argument processing functionality imported from arguments.sh.  <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script <br> |
| processDirectory(projSubDir,&nbsp;isLib) | Perform work on one specefic project directory and convert any bash script found in the directory.  <br><br><u><b>Args:</b></u><br>projSubDir - the project sub-directory whose scripts will be processed <br>isLib - indicator to process lib sub folder <br> |
| processFile(file) | Perform work to run bashdoc on one specific file  <br><br><u><b>Args:</b></u><br>file - the script file to process <br> |
