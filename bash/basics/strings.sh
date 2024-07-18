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

# Replace newline characters (cr and lf) to space
# 
# @param text - text to perform replacement
# @output - the trimmed text on standard output
function newLinesToSpace() {
  echo "$1" | tr "\r\n" " "
}

# Trim newline characters (cr and lf)
# 
# @param text - text to perform trim
# @output - the trimmed text on standard output
function trimNewLines() {
  echo "$1" | tr -d "\r\n"
}


# Padding text
echo "Pad  Left:$(padLeft "text" 15 '_')"
echo "Pad Right:$(padRight "hello world" 15 '~')"
echo ""

# spliting text values
text="one,two,three"
delim=","
declare -a array=()
for val in $(echo "$text" | tr "$delim" "\n"); do
  array+=($val)
done
echo "Array Len: ${#array}"
for item in "${array[@]}"; do echo "  ${item}"; done

# replace characters
text=$'one\ntwo\rthree\r\n'
text=$(trimNewLines "$text")
echo "Trim New Lines: $text"

text=$'one\ntwo\rthree\r\n'
text=$(newLinesToSpace "$text")
echo "Replace New Lines: $text"