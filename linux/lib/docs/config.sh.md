<small><i>Auto-generated using bashdoc.sh</i></small>
# [config.sh](../config.sh)

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
| hasProperty($1,$2) | Check if the config file has property name  <br><br><u>Args:</u><br>$1 - The config file <br>$2 - the property name <br><br><u>Return:</u><br>0 (zero) when true, 1 otherwise<br> |
| getProperty($1,$2) | Get the property value  <br><br><u>Args:</u><br>$1 - The config file <br>$2 - the property name <br><br><u>Return:</u><br>0 (zero) when value is written to standard output, 1 otherwise<br> |
