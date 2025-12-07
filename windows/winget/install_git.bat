@echo off

REM -e ensures an exact match for the package ID 
echo Installing Git...
winget install --id Git.Git -e

REM pause the script to see the output
pause
