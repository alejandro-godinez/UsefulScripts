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

@version: 2023.8.3

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
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
| showYestNoPrompt() | Ask user to confirm if the file that was found is the one intended  to be installed.   |
| promptForInstall() | Ask user which project they would like to install from the set    @return - exit value of zero (truthy) indicates installDir variable set   |
| installProject($1) | Perform installation of scripts for the specified project sub directory.    <br><br><u>Args:</u><br>$1 - the project sub-directory from which to install scripts  <br> |
| installSingleFile() | Perform the work to find the single file to install   |
| installFile($1,$2) | Perform install work for a file   <br><br><u>Args:</u><br>$1 - the file to install  <br>$2 - the destination path into which file should be installed  <br> |
| findFile($1) | Find the first file that is found to match the name specified    <br><br><u>Args:</u><br>$1 - the file name to search  <br> |
| pathHasLibFolder($1) | Check if the specified path contains a lib folder    <br><br><u>Args:</u><br>$1 - the path to check  <br> |
