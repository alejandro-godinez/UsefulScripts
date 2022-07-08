#!/bin/bash
#------------------------------------------------------------------------
# This script will add a comment "#" to the start of the line number(s)
# specified.
#
# Usage:
#   comment <startLine>[,<endLine>] <file>
#
#     startLine - the single line number to comment
#     endLine   - the ending line number in a range of lines to comment
#     file      - the file to perform the stream edit
#
# Example:  comment 4,6 file.txt
#  - Comment line numbers 4 thru 6 in file.txt
#-------------------------------------------------------------------------
sed -i "$1"' s/^/#/' "$2"
