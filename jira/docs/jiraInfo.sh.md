<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [jiraInfo.sh](../jiraInfo.sh)

 Fetch information for a given jira issue/ticket/work item id
 the request results are cached in a local file for subsequent 
 field lookups.  You can use the -u option to force an update of the cached file.



 ### Requirements:
 - The script expects a configuration file at ~/auth/jira.config  
   - SEE: [Sample Config File](../config/jira_sample.config)
 - The script requires the `jq` command to be installed for parsing JSON output.
   - SEE: [jq Installation Guide](https://stedolan.github.io/jq/download/)
   - TIP: ```winget install jqlang.jq -e```

 ### Usage:
 <pre>
 jiraInfo.sh [options] &lt;issueId&gt;
   Options:
     -h         This help text info
     -v         Verbose/debug output
     -u         Update jira info output even if it already exists

   Output Options:
     -f         Print the full jira issue info (default)
     -b         Print basic info
     -t         Print type info
     -s         Print status info
     -p         Print project info
     -c         Print creator info
     -r         Print reporter info
     -a         Print assignee info
     -y         Print priority info
 </pre>

 ### Usage Example:
 <pre>
 Full Info:     jiraInfo.sh JRA-123
 Specific Info: jiraInfo.sh -b -t -s JRA-123
 Force Update:  jiraInfo.sh -u JRA-123
 </pre>



## Functions:
| Function | Description |
|----------|-------------|
| printHelp() |  Print the usage information for this script to standard output.  |
| processArgs(args) |  Setup and execute the argument processing functionality imported from arguments.sh.  <br><br><u><b>Args:</b></u><br>args - array of argument values provided when calling the script <br> |
| loadConfig() |  Perform work to load settings from config file  |
