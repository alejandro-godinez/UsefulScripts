# UsefulScripts
An assortment of useful scripts from a wide variety of technologies.

### [ANT](ant/readme.md)
- **build_junit.xml**  
A largley re-usable ANT build script for any standalone java project that will execute and halt on failed JUnit tests.

### [BashDoc](bashdoc/bashdoc.sh.md)
Parse documentation comments from bash script and generate markdown

### [Git](git/readme.md)
- **gitBranchList.sh**  
List the current branch name for git projects in the current directory

- **gitPullMain.sh**  
Prompts to perform a pull for git projects in the current directory

- **gitStashList.sh**  
Lists the stash entries for each project in the current directory

- **gitTrimStash.sh**  
Perform a trim (drop) of the oldes stash entries down to a set number of items.

- **Libraries**  
    - **git_lib.sh** - Various GIT functions to obtain repo information or perform operations.

### [Linux](linux/readme.md)
- **avgFileSize.sh**  
Get an average file size of all the files that meet the specified name filter.

- **changeOptionValue.sh**  
Change the value of a standard "name=value" pair such as ini or config files.

- **comment.sh**  
Add a comment "#" to the start of the line number(s) specified.

- **findFileInTarGzip.sh**  
Search the contents of any '.tar.gz' file in the specified directory for entries with matching specified search text.

- **findFilesWithText.sh**  
Search the contents of file in sub-directories from the working path for content that matches the specified search text.

- **findFilesWithTextInTarGzip.sh**  
search the contents of any '.tar.gz' file in the specified directory for entries with matching specified search text.

- **findLargestFiles.sh**    
Find the largest files for the specified directory recursively.

- **jarinfo.sh**  
Display the contents of the manifest file inside of the jar file specified.

- **sortFilesIntoYearFolders.sh**  
Move all files in the working directory into a sub-folder of the year equal to the last modified date.

- **unzipAll.sh**  
Extract all '.tar.gz' file into the working directory.

- **Libraries**  
    - **logging.sh** - Implementation of verbose toggle for console output. Add as many console output code that will only output if debug is enabled.


### Maven  
- **installToMaven.sh**  
Installs a java project to your local maven repository. Useful for re-using in-house libraries in other maven projects.

### Nano
- **createNanoRCFile.sh**  
Create the .nanorc file in the home directory that is needed to enable the code highlighting in the nano editor.   

- **unibasic.nanorc**  
Syntax highlighting for the UniBasic database language.

### Notepad++
- **TimeLog.xml**  
Syntax highlighting for simple time tracking text file.

- **UniBasic_Functions.xml**  
Autocomplete Function definitions for the UniBasic database language.

- **UniBasic_Highlight.xml**  
Syntax highlighting for the UniBasic database language.


### Windows
- **ClearNetUse.bat**  
Simple command used to clear all cached net user authentication

- **commandLineHere.bat**  
Launch a terminal in the current working directory. Useful for older windows systems.

- **DisplayInfo.bat**  
Display values of some useful windows environment variables.

- **runEclipse.bat**  
Launch an eclipse project that resides in the current directory. Better way than Eclipse's bad project selection.
