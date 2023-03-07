#!/bin/bash
#----------------------------------------------------------
# This script will change the value of a standard
# name=value pair such as ini or config files.
#
#Usage:
#  changeOptionValue.sh <file> <optionName> <optionValue>
#
#    file        - the file which contains name=value data
#    optionName  - the name of the option to change
#    optionValue - the new value to update into the option
#----------------------------------------------------------

#//check if missing paramters or user specified 'help'
file=$1
if [[ $# -eq 0 ]] || [[ -z "${file// }" || "$file" == "help"  ]]; then
  #//print usage info
  echo "This script will change the value of a standard 'name=value' pair"
  echo "such as ini or config files."
  echo ""
  echo "Usage: "
  echo "  changeOptionValue.sh <file> <optionName> <optionValue>"
  echo ""
  echo "  file        - the file which contains name=value data"
  echo "  optionName  - the name of the option to change"
  echo "  optionValue - the new value to update into the option"
  echo ""
  exit 1
fi

#//check if specified file does not exist
if [[ ! -f  $file ]]; then
  echo "File specified was not found"
  exit 1
fi
echo "FILE: ${file}"

#//get and check if the option name was specified
optionName=$2
if [[ -z "${optionName// }" ]]; then
  echo "Option name no specified."
  exit 1
fi
echo "Option Name: ${optionName}"

#//get and check if the option value was specified
optionValue=$3
if [[ -z "${optionValue// }" ]]; then
  echo "Option value not specified."
  exit 1
fi
echo "Option Value: ${optionValue}"

#//check to see if the specified option name exists
optionExists=$( grep -c "^${optionName}=" "${file}" )
if [[ ${optionExists} == 0 ]]; then
  echo "The specified option name was not found."
  exit 1
fi

#//check to see if the specified option already is already set to the same value
alreadySet=$( grep -c "^${optionName}=${optionValue}" "${file}" )
#echo "Already Set: ${alreadySet}"

if [[ ${alreadySet} == 1 ]]; then
  echo "The option already has the value specified."
  exit 0
else
  echo "Updating the option..."
  sed -i "s/^${optionName}=.*/${optionName}=${optionValue}/" "${file}"
fi

#//check if the value was changed
echo "Checking if value was changed..."
alreadySet=$( grep -c "^${optionName}=${optionValue}" "${file}" )
if [[ $alreadySet == 0 ]]; then
  alreadyset="No"
else
  alreadySet="Yes"
fi
echo "Changed?: $alreadySet"

echo "Done"
