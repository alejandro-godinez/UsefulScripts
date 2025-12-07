@echo off

REM -e ensures an exact match for the package ID 
echo Installing Steam...
winget install --id Valve.Steam -e

REM pause the script to see the output
pause