#!/bin/bash
#-------------------------------------------------------------------------------
# Library implementation with function to perform common string operations
# 
# Import Sample Code:
# <pre>
# if [[ ! -f ~/lib/strings.sh ]]; then
#   echo "ERROR: Missing spinner.sh library"
#   exit
# fi
# source ~/lib/strings.sh
# </pre>
#-------------------------------------------------------------------------------

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


# - - - TESTING - - - #
# @break

# Padding text
# echo "Pad  Left:$(padLeft "text" 15 '_')"
# echo "Pad Right:$(padRight "hello world" 15 '~')"
# echo ""
