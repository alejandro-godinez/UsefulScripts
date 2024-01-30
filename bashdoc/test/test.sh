#!/bin/bash

#-------------------------------------------------------------------------------------------
# Script description section
# with multiple lines
# 
# <pre>
# preformated text
# </pre>
#-------------------------------------------------------------------------------------------

# Run test
# @param arg1 - first argument
# @keyword - some text
function runTest {
  echo "do some work"
}

# Should not be documented
# @param arg1 - first argument
# @keyword - some text
# @ignore
function shouldNotBeDocumented {
  echo "no documentation"
}


#< - - - Main - - - >
# @break

runTest