# UsefulScripts
An assortment of useful scripts from a wide variety of technologies.

### [Install](docs/install.sh.md)
- **[install.sh](install.sh)**  
Script to install the various bash scripts and libraries from this project

### [ANT](ant/readme.md)
- **build_junit.xml**  
A largley re-usable ANT build script for any standalone java project that will execute and halt on failed JUnit tests.

### [BashDoc](bashdoc/docs/bashdoc.sh.md)
Parse documentation comments from bash script and generate markdown

### [Git](git/readme.md)
- **[gitCurrentBranch.sh](git/docs/gitCurrentBranch.sh.md)**  
List the current branch name for git projects in the current directory

- **[gitFetch.sh](git/docs/gitFetch.sh.md)**  
Perform a fetch on each project in the current directory 

- **[gitPullMain.sh](git/docs/gitPullMain.sh.md)**  
Prompts to perform a pull for git projects in the current directory

- **[gitRevCount.sh](git/docs/gitRevCount.sh.md)**  
Gets a count of revisions ahead and behind from main

- **[gitStashList.sh](git/docs/gitStashList.sh.md)**  
Lists the stash entries for each project in the current directory

- **[gitStashPullApply.sh](git/docs/gitStashPullApply.sh.md)**  
Perform a stash-pull-apply sequence of operations for the project in the current directory

- **[gitStatusList.sh](git/docs/gitStatusList.sh.md)**  
This script will perform a git status, in short form, for each project in the current directory.

- **[gitTrimStash.sh](git/docs/gitTrimStash.sh.md)**  
Perform a trim (drop) of the oldes stash entries down to a set number of items.

- **Libraries**  
    - **[git_lib.sh](git/lib/docs/git_lib.sh.md)** - Various GIT functions to obtain repo information or perform operations.

### [Bash](bash/readme.md)
- **[avgFileSize.sh](bash/docs/avgFileSize.sh.md)**  
Get an average file size of all the files that meet the specified name filter.

- **[changeOptionValue.sh](bash/docs/changeOptionValue.sh.md)**  
Change the value of a standard "name=value" pair such as ini or config files.

- **[comment.sh](bash/docs/comment.sh.md)**  
Add a comment "#" to the start of the line number(s) specified.

- **[findFileInTarGzip.sh](bash/docs/findFileInTarGzip.sh.md)**  
Search the contents of any '.tar.gz' file in the specified directory for entries with matching specified search text.

- **[findFilesWithText.sh](bash/docs/findFilesWithText.sh.md)**  
Search the contents of file in sub-directories from the working path for content that matches the specified search text.

- **[findFilesWithTextInTarGzip.sh](bash/docs/findFilesWithTextInTarGzip.sh.md)**  
search the contents of any '.tar.gz' file in the specified directory for entries with matching specified search text.

- **[findLargestFiles.sh](bash/docs/findLargestFiles.sh.md)**    
Find the largest files for the specified directory recursively.

- **[jarinfo.sh](bash/docs/jarinfo.sh.md)**  
Display the contents of the manifest file inside of the jar file specified.

- **[sortFilesIntoYearFolders.sh](bash/docs/sortFilesIntoYearFolders.sh.md)**  
Move all files in the working directory into a sub-folder of the year equal to the last modified date.

- **[unzipAll.sh](bash/docs/unzipAll.sh.md)**  
Extract all '.tar.gz' file into the working directory.

- **[upcaseSql.sh](bash/docs/upcaseSql.sh.md)**
Perform upercase operation on SQL keyword.

- **Libraries**  
    - **[arguments.sh](bash/lib/docs/arguments.sh.md)** - functions to handle command line arguments in scripts
    - **[arrays.sh](bash/lib/docs/arrays.sh.md)** - helper functions for arrays
    - **[config.sh](bash/lib/docs/config.sh.md)** - function for name/value pair from config file
    - **[directoryStack.sh](bash/lib/docs/directoryStack.sh.md)** - functions for using the bash directory stack
    - **[logging.sh](bash/lib/docs/logging.sh.md)** - Implementation of verbose toggle for console output. Add as many console output code that will only output if debug is enabled.  
    - **[prompt.sh](bash/lib/docs/prompt.sh.md)** - Re-usable user input prompt methods
    - **[spinner.sh](bash/lib/docs/spinner.sh.md)** - Implementation of rotating character to show work activity
    - **[strings.sh](bash/lib/docs/strings.sh.md)** - Helper string functions
    - **[system.sh](bash/lib/docs/system.sh.md)** - system information helper methods

### Maven  
- **[installToMaven.sh](maven/docs/installToMaven.sh.md)**  
Installs a java project to your local maven repository. Useful for re-using in-house libraries in other maven projects.

### Nano
- **[createNanoRCFile.sh](nanorc/docs/createNanoRCFile.sh.md)**  
Create the .nanorc file in the home directory that is needed to enable the code highlighting in the nano editor.   

- **[unibasic.nanorc](nanorc/unibasic.nanorc)**  
Syntax highlighting for the UniBasic database language.

- **[delphi.nanorc](nanorc/delphi.nanorc)**  
Syntax highlighting for the Delphi7 language.

### [Notepad++](notepad++/readme.md)
- **TimeLog.xml**  
Syntax highlighting for simple time tracking text file.

- **UniBasic_Functions.xml**  
Autocomplete Function definitions for the UniBasic database language.

- **UniBasic_Highlight.xml**  
Syntax highlighting for the UniBasic database language.

### [ProjectFolders](projectFolders/docs/newProject.sh.md)
Bash script to create new project notes folders from a template.

### [TimeLog](timelog/docs/timelog.sh.md)
Bash script to parse through and output time information for tasks in [TimeLog](notepad++/TimeLog.xml) files.

### Windows
- **ClearNetUse.bat**  
Simple command used to clear all cached net user authentication

- **commandLineHere.bat**  
Launch a terminal in the current working directory. Useful for older windows systems.

- **DisplayInfo.bat**  
Display values of some useful windows environment variables.

- **runEclipse.bat**  
Launch an eclipse project that resides in the current directory. Better way than Eclipse's bad project selection.
