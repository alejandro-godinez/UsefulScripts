#!/bin/bash

#--------------------------------------------------------------------------------
#  braceExpansion - create sets using alternative combinations.
#  Bash Notes:
#    {start..end..increment} - sequential range set with increment
#--------------------------------------------------------------------------------

set -o posix

echo "single set"
echo a{x,y,z}b
echo ""

echo "multiple sets"
echo {a,b,c}{x,y,z}{0,1}
echo ""

echo "generate a file list of possible alternatives"
echo *.{png,jp{e}g}
echo ""

echo "use with file list command"
ls *{Associative,Indexed}.sh
echo ""

echo "sequential ranges"
echo {0..10}
for num in {0..9}; do
  echo -n $num
done
echo ""
echo ""

echo "sequential ranges with increment"
echo {0..10..2}
echo ""

echo "Fail - Brace Expansion is performed before Parameter expansion, range is not determined"
start=1; end=9
echo {$start..$end}
echo "Use eval to perform variable expansion first"
eval echo {$start..$end}
