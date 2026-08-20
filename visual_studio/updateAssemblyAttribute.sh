#!/bin/bash
#-------------------------------------------------------------------------------
# This script will update the AssemblyAttribute in the project file to include
# the InternalsVisibleTo attribute for the specified test project. This will
# allow the test project to access internal classes and members of the project
# being tested.
#-------------------------------------------------------------------------------

#//bash shell options
set -u #//error on unset variable
set -e #//exit on error

# echo print colors
RED='\033[0;31m'

# Path to project file of project being tested
PROJECT_FILE="path/to/project.csproj"

# name of the test project
TEST_PROJECT="UnitTestProject"

# Ensure $TEST_PROJECT is defined
if [ -z "$TEST_PROJECT" ]; then
  echo -e "${RED}Error: TEST_PROJECT variable is not defined.${NC}"
  exit 1
fi

# Check if project file has already been updated
if grep -q "$TEST_PROJECT" "$PROJECT_FILE"; then
    echo "Project has already been updated"
    exit 0
fi

# Create a temporary file for content
TEMP_FILE=$(mktemp)

# Check if temporary file was created successfully
if [ ! -f "$TEMP_FILE" ]; then
  echo -e "${RED}Error: Failed to create a temporary file.${NC}"
  exit 1
fi

# Add the XML content to the temporary file (avoid issues with git bash newline)
cat <<EOL > "$TEMP_FILE"
  <ItemGroup>
    <AssemblyAttribute Include="System.Runtime.CompilerServices.InternalsVisibleTo">
      <_Parameter1>$TEST_PROJECT</_Parameter1>
    </AssemblyAttribute>
  </ItemGroup>
EOL

# insert the content before the closing </Project> tag
#   -i.bak creates a backup file with the .bak extension
#   /e appends content after the matched line
sed -i.bak -e "/<\/Project>/e cat $TEMP_FILE" "$PROJECT_FILE"

# Clean up the temporary file
rm "$TEMP_FILE"

echo "Project file was updated!"