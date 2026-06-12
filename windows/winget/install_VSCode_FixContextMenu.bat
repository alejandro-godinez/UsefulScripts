@echo off

REM -e ensures an exact match for the package ID 
echo Upgrading Visual Studio Code...
winget upgrade --id Microsoft.VisualStudioCode --override "/VERYSILENT /MERGETASKS=addcontextmenufiles,addcontextmenufolders,addtopath"

REM pause the script to see the output
pause



