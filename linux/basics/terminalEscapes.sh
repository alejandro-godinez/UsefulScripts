#!/bin/bash

#-----------------------------------------------------------------------------
#  Terminal Escape Sequence
#    1. ESC - sequence starting with escape
#    2. CSI - control sequence introducer
#    3. DCS - device control string
#    4. OSC - operating system command
# 
#  Bash Notes:
#  - Escape     
#     Octal:        \033
#     Unicode:      \u001b
#     Hexadecimal:  \x1B
#     Decimal:      27
#  - [      Conrol Sequence Introducer (CSI)
#  - ;      Arguments delimiter after CSI 
# 
# References:
# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
#-----------------------------------------------------------------------------


#//bash shell options
set -u #//error on unset variable
set -e #//exit on error


echo "Line 1"
echo "Line 2"
echo "Line 3"
echo "Line 4"
echo -n "Line to be deleted"
sleep 1

# erase entire line
echo -en "\033[2K" 

# move cursor back to start of line
echo -en "\r"
sleep 1

# move cursor back to start of line
echo -n "Line after delete"
sleep 1

# move cursor up 2 lines
echo -en "\033[2A"
sleep 1

# move cursor up 2 lines
echo -en "\rLine after 2 line move up"
sleep 1

# move cursor to column 12 to change the number 2 to X
echo -en "\033[12G"
echo -n "X"
sleep 1

# move cursor to begging of next line
echo -en "\033[1E"
echo -n "Line 3 not 4"
sleep 1

# move cursor to begging of previous line, 3 lines up
echo -en "\033[3F"
echo -n "Line 1 (one)"
sleep 1

# move cursor to home (0,0)
echo -en "\033[H"
# erase from cursor to the end of screen (same as '\033[0J' )
echo -en "\033[J"
sleep 1

#echo -en "\033[2B" # move cursor up
