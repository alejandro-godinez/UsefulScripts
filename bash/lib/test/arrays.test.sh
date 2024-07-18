#!/bin/bash

# define list of libraries and import them
declare -a libs=( ../arrays.sh )
for lib in "${libs[@]}"; do 
  if [[ ! -f $lib ]]; then
    echo -e "${RED}ERROR: Missing $lib library${NC}"
    exit
  fi 
  source "$lib"
done

# Run test
#
# @param var - test param
# @ignore
function runTest {
  local -A keywordMap=()

  keywordType="ignore"
  commentText="Some comment"

  # check if keyword name already exists in map, if so append text
  if ! arrayHasKey keywordMap $keywordType; then
    #if [[ ! -v keywordMap[$keywordType] ]]; then
    echo "  Adding new parameter '${keywordType}' to list..."
    keywordMap[$keywordType]="$commentText"
  else
    echo "  Updating additional comment to '[$keywordType]'..."
    keywordMap[$keywordType]="${keywordMap[$keywordType]} ${commentText}"
  fi

  arrayPrint keywordMap

  keywordType="ignore"
  commentText="Another comment"

  # check if keyword name already exists in map, if so append text
  if ! arrayHasKey keywordMap $keywordType; then
    #if [[ ! -v keywordMap[$keywordType] ]]; then
    echo "  Adding new parameter '${keywordType}' to list..."
    keywordMap[$keywordType]="$commentText"
  else
    echo "  Updating additional comment to '[$keywordType]'..."
    keywordMap[$keywordType]="${keywordMap[$keywordType]} ${commentText}"
  fi

  arrayPrint keywordMap

}

runTest