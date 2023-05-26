## Installation Note
As is common you can post scripts in your home bin folder so that they are available anywhere in bash. Most if not all of the git scripts in this section make use of library scripts, make sure to also install dependencies.

**Dependencies**  
  _Include the following in a lib folder in your bash home directory_  
  - [logging.sh](../linux/lib/logging.sh)

<br><br>

# [avgFileSize.sh](avgFileSize.sh)
This script will get an average file size of all the file that meet the specified name filter.

**Sample:**
```
$ avgFileSize.sh "*.ini"
Search: *.ini
Dir: /temp/
Total (KiB): 0.6934
File Count: 11
Average (KiB): 0.0630
```

# [changeOptionValue.sh](changeOptionValue.sh)
This script will change the value of a standard name=value pair file such as ini or config files.

**Sample:**
```
$ cat test.ini
[section]
name=Alejandro
  indented=true
location=earth

$ changeOptionValue.sh test.ini "indented" "false"
FILE: test.ini
Option Name: indented
Option Value: false
Updating the option...
Checking if value was changed...
Changed?: YES

$ cat test.ini
[section]
name=Alejandro
  indented=false
location=earth
```

# [comment.sh](comment.sh)
This script will add a comment "#" to the start of the line number(s) specified.

**Sample:**
```
$ cat script1.sh
#!/bin/bash
clear
echo "Last 10 lines of system log file"
echo "--------------------------------"
tail /var/log/messages

$ comment.sh 5 script1.sh

$ cat script1.sh
#!/bin/bash
clear
echo "Last 10 lines of system log file"
echo "--------------------------------"
#tail /var/log/messages
```

# [findFileInTarGzip.sh](findFileInTarGzip.sh)
This script will search the contents of any '.tar.gz' file in the specified directory for entries with matching specified search text.

**Sample:**
```
$ findFileInTarGzip.sh "script3"
Search: script3
DIR: /temp/
Depth Search: 1

/temp/userfiles.tar.gz
-rwxr-xr-x alex/1049089 151 2023-03-08 16:58 scripts/script3.sh

/temp/userfiles2.tar.gz
-rwxr-xr-x alex/1049089 151 2023-03-08 16:58 scripts/script3.sh
```

# [findFilesWithText.sh](findFilesWithText.sh)
This script will search the contents of file in sub-directories from the working path for content that matches the specified search text.

# [findFilesWithTextInTarGzip.sh](findFilesWithTextInTarGzip.sh)
This script will search the contents of tar gzip files in the specified directory for entries with matching specified search text.

# [findLargestFiles.sh](findLargestFiles.sh)
This script will find the largest files for the specified directory recursively.

# [jarinfo.sh](jarinfo.sh)
This script will display the contents of the manifest file inside of the jar file specified.

**Sample:**
```
$ jarinfo.sh pdfbox-app-2.0.27.jar
JAR File: pdfbox-app-2.0.27.jar
Manifest Path: META-INF/MANIFEST.MF
COMMAND: unzip -q -c pdfbox-app-2.0.27.jar META-INF/MANIFEST.MF


Manifest-Version: 1.0
Bnd-LastModified: 1664205534305
Build-Jdk: 1.8.0_202
Built-By: lehmi
Bundle-Description: The Apache Software Foundation provides support
...
```

# [sortFilesIntoYearFolderes.sh](sortFilesIntoYearFolderes.sh)
This script will list all the files in the current working directory and move the file into a sub-folder of the year equal to the last modified date.

# [unzipAll.sh](unzipAll.sh)
This script unzips all 'tar.gz' files in the current working directory.
