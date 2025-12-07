@echo off

REM -e ensures an exact match for the package ID 
echo Installing DBeaver Community...
winget install --id DBeaver.DBeaver.Community -e

REM pause the script to see the output
pause
