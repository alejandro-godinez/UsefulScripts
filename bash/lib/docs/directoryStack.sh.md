<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [directoryStack.sh](../directoryStack.sh)

 Library of various functions to facilitate the user of the bash directory
 stack.


 Import Sample Code:
 <pre>
 if [[ ! -f ~/lib/directoryStack.sh ]]; then
   echo "ERROR: Missing directoryStack.sh library"
   exit
 fi
 source ~/lib/directoryStack.sh
 </pre>

 Usage:
 <pre>
 # gets index of folder using full path
 index=$(stackIndex /some/path/to/folderone)
 # gets index of older using some part of path
 index=$(stackIndex folderone)

 # switches to path that is not on the stack by adding to stack (pushd)
 stackSwitch /some/path/to/foldertwo
 # switches to path that is on the stack

 stackSwitch /some/path/to/foldertwo
 # switches to path that is on the stack using part of path
 stackSwitch folderone
 </pre>


## Functions:
| Function | Description |
|----------|-------------|
| stackIndex(dir) |  Gets the stack index of the specified directory if it exists, -1 otherweise   Notes:    - dir path argument can be a partial path, such as the folder name   - will only return index of first match in stack  <br><br><u><b>Args:</b></u><br>dir - the directory path to serach in the stack <br><br><u><b>Return:</b></u><br>0 (zero) when found, 1 otherwise <br><br><u><b>Output:</b></u><br>index of dir in path, -1 when not found <br> |
| stackSwitch(dir) |  Switches to the specific directory path from the stack if a match exist, otherwise it  push another entry onto the stack.  Notes:    - dir path argument can be a partial path, such as the folder name   - will only return index of first match in stack  <br><br><u><b>Args:</b></u><br>dir - the directory path to serach in the stack <br><br><u><b>Return:</b></u><br>0 (zero) with swich, 1 otherwise <br> |
