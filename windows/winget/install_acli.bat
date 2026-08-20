@echo off

REM -e ensures an exact match for the package ID 
echo Installing Atlassian.AtlassianCLI...
winget install --id Atlassian.AtlassianCLI -e

REM pause the script to see the output
pause
