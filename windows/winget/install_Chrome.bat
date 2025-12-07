@echo off

REM -e ensures an exact match for the package ID 
echo Installing Chrome...
winget install --id Google.Chrome.EXE -e

REM pause the script to see the output
pause