<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [newProject.sh](../newProject.sh)

Create a new project work folder for the specified ticket number and description.  
A copy of the template folder is copied to the current working directory or a specific
output path if the provided option (-o) is used. The template directory is expected to
be installed to a data home directory but can be changed to be elsewhere.

@version 2023.12.19

Usage:<br>
<pre>
newProject.sh [options] <ticket> [description]
  -h           This help info
  -v           Verbose/debug output
  -o path      Output path
</pre>

Examples:
<pre>
./newProject.sh ABC-1245 "New script to create project folder"
./newProject.sh -o "01-Assigned" "ABC-1245" "New script to create project folder"
</pre>


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| loadConfig() | Load configuration properties from config file   |
| processArgs(args) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script  <br> |
