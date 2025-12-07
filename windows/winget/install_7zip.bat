@echo off

REM -e ensures an exact match for the package ID 
echo Installing 7-Zip...
winget install --id 7Zip.7Zip -e

REM pause the script to see the output
pause
