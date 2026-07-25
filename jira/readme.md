## Installation Note
As is common you can post scripts in your home bin folder so that they are available anywhere in bash. Most if not all of the git scripts in this section make use of library scripts, make sure to also install dependencies.

**Dependencies**  
  _Include the following in a lib folder in your bash home directory_  
  - [logging.sh](../bash/lib/docs/logging.sh.md)
  - [arguments.sh](../bash/lib/docs/arguments.sh.md)
  - [config.sh](../bash/lib/docs/config.sh.md)
  - [jira_lib.sh](lib/docs/jira_lib.sh.md)

  For convenience [Install](../docs/install.sh.md) script is provided at the root of this repo.

## Dev Notes
  Consider the following tools for development
  - [shellCheck](../docs/devTools.md#shellcheck) - bash script code analysis

# [jiraInfo.sh](docs/jiraInfo.sh.md)
This script fetches information for a jira work item (ticket).

**Samples:**
```
#// default options, will read from cache file if already fetch info before
$ jiraInfo.sh SCRIPTS-2
Loading configuration...
https://godale.atlassian.net/
Output File: /c/Users/username/temp/jira/SCRIPTS-2.log
Output file already exists, reading from file...
Checking for errors in issue info...
----------- Issue Info -----------
Issue ID: 10033
Issue Key: SCRIPTS-2
Issue Summary: Bash - Create script that will obtain JIRA info through REST request
...


# // force a fetch and display only basic information
$ jiraInfo.sh -u -b SCRIPTS-2
Loading configuration...
https://godale.atlassian.net/
Output File: /c/Users/elflo/temp/jira/SCRIPTS-2.log
Output file already exists, reading from file...
Output file does not exist, fetching issue info from API...
Getting Issue Info...
  % Total    % Received % Xferd  Average Speed  Time    Time    Time   Current
                                 Dload  Upload  Total   Spent   Left   Speed
100   6377   0   6377   0      0  10828      0                              0
Checking for errors in issue info...
----------- Issue Info -----------
Issue ID: 10033
Issue Key: SCRIPTS-2
Issue Summary: Bash - Create script that will obtain JIRA info through REST request

```