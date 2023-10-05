<small><i>Auto-generated using bashdoc.sh</i></small>
# [createNanoRCFile.sh](../createNanoRCFile.sh)

This script will create the .nanorc file in the home
directory that is needed to enable the code highlighting
in the nano editor

@version 2023.10.05

Usage:<br>
<pre>
createNanoRCFile.sh [option]

Options:
  -h           This help info
  -v           Verbose/debug output
  -a           Add all nano syntax files from share directory when highlight is not enabled on user's login"
</pre>



## Functions:
| Function | Description |
|----------|-------------|
| printHelp() | Print the usage information for this script to standard output.   |
| processArgs($1) | Setup and execute the argument processing functionality imported from arguments.sh.    <br><br><u>Args:</u><br>$1 - array of argument values provided when calling the script  <br> |
| promptYesNo() | Generic function to prompt user for input    @return - exit value of zero indicates yes (bash no error)   |
| createNanoRCFile() | Creates a new nanorc file   |
| includeSyntaxFromInstall() | add include statements for each of the files in the user share    |
| includeSyntaxFromProject() | copies project syantax file to local home nano directory and adds include  statement to the nanorc file   |
