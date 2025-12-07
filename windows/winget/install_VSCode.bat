@echo off

REM -e ensures an exact match for the package ID 
echo Installing Visual Studio Code...
winget install --id Microsoft.VisualStudioCode -e

REM pause the script to see the output
pause