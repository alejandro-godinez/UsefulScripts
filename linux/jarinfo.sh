#!/bin/bash
#----------------------------------------------------------
# This script will display the contents of the manifest
# file inside of the jar file specified.  
# 
# Version: 2021.12.3
#----------------------------------------------------------

#//check if missing paramters or user specified 'help'
if [[ $# -eq 0 ]] || [[ -z "${1// }" || "${1}" == "help"  ]]; then
  #//print usage info
  echo "This script will display the contents of the manifest"
  echo "file inside of the jar file specified."
  echo ""
  echo "Usage: "
  echo "  jarinfo.sh <jarfile> [manifestPath]"
  echo ""
  echo "  jarfile      - the jar file path"
  echo "  manifestPath - alternative path to manifest (or any other file)"
  echo "                 default to 'META-INFO/MANIFEST.MF'"
  echo ""
  exit 1
fi
jarFile=${1}
echo "JAR File: ${jarFile}"

#//check if alternative manifest parametera was specified
if [ -z "${2// }" ]; then
  manifestPath="META-INF/MANIFEST.MF"
else
  manifestPath=${2}
fi
echo "Manifest Path: ${manifestPath}"

#result=$( unzip -q -c ${jarFile} ${manifestPath} )
echo "COMMAND: unzip -q -c ${jarFile} ${manifestPath}"
echo ""
echo ""

#//perform unzip to standard output (-q=quiet -c=extract to stdout)
unzip -q -c ${jarFile} ${manifestPath}
