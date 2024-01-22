## Installation Note
As is common you can post scripts in your home bin folder so that they are available anywhere in bash. Most if not all of the git scripts in this section make use of library scripts, make sure to also install dependencies.

**Dependencies**  
  _Include the following in a lib folder in your bash home directory_  
  - [git_lib.sh](lib/docs/git_lib.sh.md)
  - [logging.sh](../linux/lib/docs/logging.sh.md)
  - [arguments.sh](../linux/lib/docs/arguments.sh.md)

  For convenience [Install](../docs/install.sh.md) script is provided at the root of this repo.

<br><br>

# [gitBranchList.sh](docs/gitBranchList.sh.md)
This script will list the current branch for each of the git project folders in the current directory.  When already inside a git project folder it will display that projects current branch.

**Sample:**
```
$ gitBranchList.sh
Depth Search: 1
./UsefulScripts - trunk
./userDefinedLanguages - master
DONE
```

# [gitFetch.sh](docs/gitFetch.sh.md)
This script will perform a fetch on each of the git project folders in the current directory. When already inside a git project folder it will perform fetch on only that project.

**Sample:**
```
$ gitFetch.sh
./UsefulScripts
./userDefinedLanguages
```

# [gitPullMain.sh](docs/gitPullMain.sh.md)
This script will perform a pull on each of the git project folders in the current directory if it is pointing to the main branch.  The user will be interrogated to confirm pull.

**Sample:**
```
$ gitPullMain.sh
Current Dir: /c/Users/alex/dev
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

# [gitRevCount.sh](docs/gitRevCount.sh.md)
This script will get a count of revisions ahead and behind from master both against local and remote. You should perform a fetch so that your working directory is up to date and counts are accurate. When in the "main" branch the local compare is not done as it will always be zeros.
```
$ gitRevCount.sh
Ahead   Behind  Branch
1       0       trunk->origin/trunk

$ gitRevCount.sh
Ahead   Behind  Branch
0       1       featureBranch->trunk
0       0       featureBranch->origin/trunk
```
_Note: in the example above local trunk has a commit and featureBranch is 1 commit behind._

# [gitStashList.sh](docs/gitStashList.sh.md)
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

# [gitStashPullApply](docs/gitStashPullApply.sh.md)
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

# [gitStatusList.sh](docs/gitStatusList.sh.md)
This script will perform a git status, in short form, for each project in the current directory
```
$ gitStatusList.sh
./UsefulScripts
 M README.md
 M git/readme.md
DONE
```


# [gitTrimStash.sh](docs/gitTrimStash.sh.md)
This script will trim the stash of entries from the end/oldest down to a specified number of entries.  The script default to 3 but can be adjusted with -t option.

**Sample:**
```
$ gitTrimStash.sh -t 2
/c/Users/alex/dev/UsefulScripts
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
