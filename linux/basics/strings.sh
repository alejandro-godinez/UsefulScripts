#!/bin/bash

#-----------------------------------------------------------------------------
#  Bash Notes:
#-----------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

# Pad a string to the left with additional character up to a spcific length
#
# LIMITATION: replaces all spaces with character including those in the text
function padLeft {
  local text=$1
  local padLen=$2
  local padChar=$3
  printf "%+${padLen}s" "${text}" | tr ' ' "$padChar"
}

# Pad a string to the left with additional character up to a spcific length
#
# LIMITATION: replaces all spaces with character including those in the text
function padRight {
  local text=$1
  local padLen=$2
  local padChar=$3
  printf "%-${padLen}s" "${text}" | tr ' ' "$padChar"
}

echo "Pad  Left:$(padLeft "text" 15 '_')"
echo "Pad Right:$(padRight "hello world" 15 '~')"

# precision=5
# result=$(printf "%.${precision}f", "0")
# echo "$result"