#!/bin/bash

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

#//set the Internal Field Separator to newline (git-bash uses spaces for some reason)
IFS=$'\n'

#//colors for echo print
NC='\033[0m' # No Color
BLK='\033[0;30m'       # Black
RED='\033[0;31m'       # Red
GRN='\033[0;32m'       # Green
YEL='\033[0;33m'       # Yellow
BLU='\033[0;34m'       # Blue
PUR='\033[0;35m'       # Purple
CYN='\033[0;36m'       # Cyan
WHT='\033[0;37m'       # White
colorList=("$BLK" "$RED" "$GRN" "$YEL" "$BLU" "$PUR" "$CYN" "$WHT")

echo "Standard Colors:"
for color in "${colorList[@]}"; do
  echo -en "  ${color}Test Color${NC}"
done
echo ""

#bold colors
B_BLK='\033[1;30m'       # Black
B_RED='\033[1;31m'       # Red
B_GRN='\033[1;32m'       # Green
B_YEL='\033[1;33m'       # Yellow
B_BLU='\033[1;34m'       # Blue
B_PUR='\033[1;35m'       # Purple
B_CYN='\033[1;36m'       # Cyan
B_WHT='\033[1;37m'       # White
colorList=("$B_BLK" "$B_RED" "$B_GRN" "$B_YEL" "$B_BLU" "$B_PUR" "$B_CYN" "$B_WHT")

echo "Bold Colors:"
for color in "${colorList[@]}"; do
  echo -en "  ${color}Test Color${NC}"
done
echo ""

#underline colors
U_BLK='\033[4;30m'       # Black
U_RED='\033[4;31m'       # Red
U_GRN='\033[4;32m'       # Green
U_YEL='\033[4;33m'       # Yellow
U_BLU='\033[4;34m'       # Blue
U_PUR='\033[4;35m'       # Purple
U_CYN='\033[4;36m'       # Cyan
U_WHT='\033[4;37m'       # White
colorList=("$U_BLK" "$U_RED" "$U_GRN" "$U_YEL" "$U_BLU" "$U_PUR" "$U_CYN" "$U_WHT")

echo "Underline Colors:"
for color in "${colorList[@]}"; do
  echo -en "  ${color}Test Color${NC}"
done
echo ""

#Intense colors
I_BLK='\033[0;90m'       # Black
I_RED='\033[0;91m'       # Red
I_GRN='\033[0;92m'       # Green
I_YEL='\033[0;93m'       # Yellow
I_BLU='\033[0;94m'       # Blue
I_PUR='\033[0;95m'       # Purple
I_CYN='\033[0;96m'       # Cyan
I_WHT='\033[0;97m'       # White
colorList=("$I_BLK" "$I_RED" "$I_GRN" "$I_YEL" "$I_BLU" "$I_PUR" "$I_CYN" "$I_WHT")

echo "Intense Colors:"
for color in "${colorList[@]}"; do
  echo -en "  ${color}Test Color${NC}"
done
echo ""

#Bold/Intense colors
BI_BLK='\033[1;90m'       # Black
BI_RED='\033[1;91m'       # Red
BI_GRN='\033[1;92m'       # Green
BI_YEL='\033[1;93m'       # Yellow
BI_BLU='\033[1;94m'       # Blue
BI_PUR='\033[1;95m'       # Purple
BI_CYN='\033[1;96m'       # Cyan
BI_WHT='\033[1;97m'       # White
colorList=("$BI_BLK" "$BI_RED" "$BI_GRN" "$BI_YEL" "$BI_BLU" "$BI_PUR" "$BI_CYN" "$BI_WHT")
echo "Bold/Intense Colors:"
for color in "${colorList[@]}"; do
  echo -en "  ${color}Test Color${NC}"
done
echo ""

#Background colors
BG_BLK='\033[40m'       # Black
BG_RED='\033[41m'       # Red
BG_GRN='\033[42m'       # Green
BG_YEL='\033[43m'       # Yellow
BG_BLU='\033[44m'       # Blue
BG_PUR='\033[45m'       # Purple
BG_CYN='\033[46m'       # Cyan
BG_WHT='\033[47m'       # White
colorList=("$BG_BLK" "$BG_RED" "$BG_GRN" "$BG_YEL" "$BG_BLU" "$BG_PUR" "$BG_CYN" "$BG_WHT")
echo "Background Colors:"
for color in "${colorList[@]}"; do
  echo -en "  ${color}Test Color${NC}"
done
echo ""

#//background/Intense colors
BGI_BLK='\033[0;100m'       # Black
BGI_RED='\033[0;101m'       # Red
BGI_GRN='\033[0;102m'       # Green
BGI_YEL='\033[0;103m'       # Yellow
BGI_BLU='\033[0;104m'       # Blue
BGI_PUR='\033[0;105m'       # Purple
BGI_CYN='\033[0;106m'       # Cyan
BGI_WHT='\033[0;107m'       # White
colorList=("$BGI_BLK" "$BGI_RED" "$BGI_GRN" "$BGI_YEL" "$BGI_BLU" "$BGI_PUR" "$BGI_CYN" "$BGI_WHT")
echo "Background Colors:"
for color in "${colorList[@]}"; do
  echo -en "  ${color}Test Color${NC}"
done
echo ""

echo "Orange Colors:"
ORNG='\033[38;5;202m'
colorList=("$ORNG" '\033[38;5;214m' '\033[38;5;166m') 
for color in "${colorList[@]}"; do
  echo -en "  ${color}Test Color${NC}"
done
echo ""


#// start color and reset later
# echo -en "${GRN}"
# echo -n "Color Start - "
# echo -n "Color continue - "
# echo -en "${NC}"
# echo "Color Reset"
