@echo off

REM -e ensures an exact match for the package ID 
echo Installing PowerToys...
winget install --id Microsoft.PowerToys -e

REM pause the script to see the output
pause