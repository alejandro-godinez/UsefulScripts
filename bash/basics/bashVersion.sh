#!/bin/bash

# bash version string
echo "BASH_VERSION = ${BASH_VERSION}"
echo ""

# Bash version array
#   BASH_VERSINFO[0]      # Major version no.
#   BASH_VERSINFO[1]      # Minor version no.
#   BASH_VERSINFO[2]      # Patch level.
#   BASH_VERSINFO[3]      # Build version.
#   BASH_VERSINFO[4]      # Release status.
#   BASH_VERSINFO[5]      # Architecture
                          # (same as $MACHTYPE).

# loop through and display values
for n in {0..5}
do
  echo "BASH_VERSINFO[$n] = ${BASH_VERSINFO[$n]}"
done

# use of associative arrays requires bash 4 and greater
if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need at least bash-4.0 to run this script."
  exit 1
fi