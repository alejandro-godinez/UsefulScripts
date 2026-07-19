<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [system.sh](../system.sh)

  Library of common operating system functions  


 ### Import Sample Code:
 <pre>
 if [[ ! -f ~/lib/system.sh ]]; then
   echo "ERROR: Missing system.sh library"
   exit
 fi
 source ~/lib/system.sh
 </pre>


## Functions:
| Function | Description |
|----------|-------------|
| isFreeBSD() |  check if system is freebsd  <br><u><b>Return:</b></u><br>if freebsd, 1 otherwise <br> |
| isLinux() |  check if system is linux  <br><u><b>Return:</b></u><br>if linux, 1 otherwise <br> |
| isWindows() |  check if system is windows  <br><u><b>Return:</b></u><br>if windows, 1 otherwise <br> |
| isMinGW() |  check if system is lighweight shell and GNU utilities for windows  <br><u><b>Return:</b></u><br>if MinGW, 1 otherwise <br> |
| isSygwin() |  check if system is POSIX compatibility layer and Linux environment emulation for Windows  <br><u><b>Return:</b></u><br>if Sygwin, 1 otherwise <br> |
| isOSX() |  check if system is mac OSX  <br><u><b>Return:</b></u><br>if mac OSX, 1 otherwise <br> |
