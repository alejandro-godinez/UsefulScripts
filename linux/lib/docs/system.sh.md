<small><i>Auto-generated using [bashdoc.sh](https://github.com/alejandro-godinez/UsefulScripts/blob/trunk/bashdoc/bashdoc.sh)</i></small>
# [system.sh](../system.sh)

  Library of common operating system functions  


 Import Sample Code:
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
| isFreeBSD() |  check if system is freebsd  |
| isLinux() |  check if system is linux  |
| isWindows() |  check if system is windows  |
| isMinGW() |  check if system is lighweight shell and GNU utilities for windows  |
| isSygwin() |  check if system is POSIX compatibility layer and Linux environment emulation for Windows  |
| isOSX() |  check if system is mac OSX  |
