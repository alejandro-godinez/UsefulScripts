#!/bin/bash
#-------------------------------------------------------------------------------
#  Library of common operating system functions
#-------------------------------------------------------------------------------

function isLinux {
  if [[ "$OSTYPE" == "freebsd"* ]]; then
    return 0
  fi
  return 1
}

function isFreeBSD {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    return 0
  fi
  return 1
}

function isWindows {
  if [[ "$OSTYPE" == "win32"* ]]; then
    return 0
  fi
  return 1
}

# check if operating system is lighweight shell and GNU utilities for windows
function isMinGW {
  if [[ "$OSTYPE" == "msys" ]]; then
    return 0
  fi
  return 1
}

# POSIX compatibility layer and Linux environment emulation for Windows
function isSygwin {
  if [[ "$OSTYPE" == "cygwin" ]]; then
    return 0
  fi
  return 1
}

#//mac OSX
function isOSX {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    return 0
  fi
  return 1
}



# - - - TESTING - - - 

echo -n "Linux:   "; isLinux && echo "TRUE" || echo "FALSE"
echo -n "FreeBSD: "; isFreeBSD && echo "TRUE" || echo "FALSE"
echo -n "Windows: "; isWindows && echo "TRUE" || echo "FALSE"
echo -n "MinGW:   "; isMinGW && echo "TRUE" || echo "FALSE"
echo -n "Sysgwin: "; isSygwin  && echo "TRUE" || echo "FALSE"
echo -n "OSX:     "; isOSX && echo "TRUE" || echo "FALSE"
