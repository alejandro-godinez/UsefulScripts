<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [config.sh](.././linux/lib/config.sh)

Library implementation with functions to read from a configuration file
with simple name value pair (i.e. name=value). The value is acquired after
the first instance of the equal sign, therefore equals character is valid in
the value.

TODO:
- Add write functionality
- Get a list of available property names

Import Sample Code:
  <pre>
    if [[ ! -f ~/lib/config.sh ]]; then
      echo "ERROR: Missing config.sh library"
      exit
    fi
    source ~/lib/config.sh
  </pre>
 
Usage:
 <pre>
   # check if property exists
   if hasProperty "name" "file.config"; then
     # get the value
     value=$(getProperty "name" "file.config")
   fi
 </pre>


## Functions:
| Function | Description |
|----------|-------------|
| hasProperty(configFile,&nbsp;propName) | Check if the config file has property name    <br><br><u><b>Args:</b></u><br>configFile - The config file  <br>propName - the property name  <br><br><u><b>Return:</b></u><br>0 (zero) when true, 1 otherwise  <br> |
| getProperty(configFile,&nbsp;propName) | Get the property value    <br><br><u><b>Args:</b></u><br>configFile - The config file  <br>propName - the property name  <br><br><u><b>Return:</b></u><br>0 (zero) when value is found and output, 1 otherwise  <br><br><u><b>Output:</b></u><br>value writtent to standard output  <br> |
