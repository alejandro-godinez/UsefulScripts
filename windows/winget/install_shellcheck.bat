@echo off

REM -e ensures an exact match for the package ID 
echo Installing shellcheck...
winget install --id koalaman.shellcheck -e

REM pause the script to see the output
pause