## Installation Note
As is common you can post scripts in your home bin folder so that they are available anywhere in bash. Most if not all of the git scripts in this section make use of library scripts, make sure to also install dependencies.

**Dependencies**  
  _Include the following in a lib folder in your bash home directory_  
  - [git_lib.sh](lib/git_lib.sh)
  - [logging.sh](../linux/lib/logging.sh)

<br><br>

# [gitBranchList.sh](gitBranchList.sh)
This script will list the current branch for each of the git project folders in the current directory.  When already inside a git project folder it will display that projects current branch.

**Sample:**
```
$ gitBranchList.sh
Depth Search: 1
./UsefulScripts - trunk
./userDefinedLanguages - master
DONE
```

# [gitPullMain.sh](gitPullMain.sh)
This script will perform a pull on each of the git project folders in the current directory if it is pointing to the main branch.  The user will be interrogated to confirm pull.

**Sample:**
```
$ gitPullMain.sh
Current Dir: /c/Users/agodinez/Dev/devMisc
Depth Search: 1
Repo Dir: ./UsefulScripts
./UsefulScripts - trunk
  Perform Pull? [Y/N] or Q to Quit: y
Already up to date.
Repo Dir: ./userDefinedLanguages
./userDefinedLanguages - master
  Perform Pull? [Y/N] or Q to Quit: n
  Skipped
```

# [gitStashList.sh](gitStashList.sh)
This script will list the stash entries of each of the git project folders in the current directory.

**Sample:**
```
$ gitStashList.sh
Depth Search: 1
./UsefulScripts
stash@{0}: WIP on trunk: d954b20 Changed default placeholder manifext main class
stash@{1}: On trunk: Updates to git documentation
DONE
```

# [gitStashPullApply](gitStashPullApply)
This script will perform a stash-pull-apply sequence of operations on the git project folder in which you are located. 

**Sample:**
```
$ gitStashPullApply.sh "Updating master before commit"
  Performing Stash...
Saved working directory and index state On trunk: Updating master before commit
  Performing pull...
Already up to date.
  Performing stash apply...
On branch trunk
Your branch is ahead of 'origin/trunk' by 1 commit.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   git/readme.md
```

# [gitTrimStash.sh](gitTrimStash.sh)
This script will trim the stash of entries from the end/oldest down to a specified number of entries.  The script default to 3 but can be adjusted with -t option.

**Sample:**
```
$ gitTrimStash.sh -t 2
/c/Users/agodinez/Dev/devMisc/UsefulScripts
stash@{0}: WIP on trunk: d954b20 Changed default placeholder manifext main class
stash@{1}: On trunk: Updating master before commit
stash@{2}: WIP on trunk: d954b20 Changed default placeholder manifext main class
stash@{3}: On trunk: Updates to git documentation
Perform Trim down to 2? [Y/N] or Q to Quit: Y
  Dropping index [3]
Dropped stash@{3} (893d7bf9f1d9a1105f4fc22f1d674011576ea721)
  Dropping index [2]
Dropped stash@{2} (357d2c1e1853fb6ce3d3a0039dab68a0d24c0cee)

```
