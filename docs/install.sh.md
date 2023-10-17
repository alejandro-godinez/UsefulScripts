<small><i>Auto-generated using bashdoc.sh</i></small>
# [install.sh](../install.sh)

This script will perform installation and detect updates of scripts. Files are
identified as install if it does not exist. Updates are detect by comparing
and finding a difference in the md5 hash of the project script and the local
copy.

Notes:<br>
- Files will be overwritten, any local config changes made will be lost
- Any change in your local copy will be detected as needing an update
<br>

@version: 2023.10.11

TODO:<br>
- Better detect changes in script, maybe by version number if one exists

Usage:<br>
<pre>
install.sh [option]

Options:
  -h           This help info
  -v           Verbose/debug output
  -m           Mock run, will display what will be installed and updated
  -a           Install all pre-defined projects
  -n filename  install a file matching the name specified, name must be exact, '.sh' extension is assumed
</pre>

Examples:
<pre>
  install.sh -n bashdoc
  - install the bashdoc.sh script
</pre>


## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.  |
| processArgs(args) | Setup and execute the argument processing functionality imported from arguments.sh.  <br><br><u>Args:</u><br>args - array of argument values provided when calling the script <br> |
| promptForInstall() | Ask user which project they would like to install from the set  <br><u>Return:</u><br>exit value of zero (truthy) indicates installDir variable set, 1 otherwise<br> |
| installProject(projDir) | Perform installation of scripts for the specified project sub directory.  <br><br><u>Args:</u><br>projDir - the project sub-directory from which to install scripts <br> |
| installSingleFile() | Perform the work to find the single file to install specified throug script option  |
| installFile(file,dest) | Perform install work for a file  <br><br><u>Args:</u><br>file - the file to install <br>dest - the destination path into which file should be installed <br> |
| findFile(fileName) | Find the first file that is found to match the name specified  <br><br><u>Args:</u><br>fileName - the file name to search <br><br><u>Return:</u><br>0 (zero) when match was found, 1 otherwise<br><br><u>Output:</u><br>the file path, writtent to standard output<br> |
| pathHasLibFolder(path) | Check if the specified path contains a lib folder  <br><br><u>Args:</u><br>path - the path to check <br><br><u>Return:</u><br>0 (zero) when true, 1 otherwise<br> |
