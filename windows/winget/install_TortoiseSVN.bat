@echo off

REM -e ensures an exact match for the package ID 
echo Installing TortoiseSVN...
winget install --id TortoiseSVN.TortoiseSVN -e

REM pause the script to see the output
pause