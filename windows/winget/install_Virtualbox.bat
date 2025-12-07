@echo off

REM -e ensures an exact match for the package ID 
echo Installing VirtualBox...
winget install --id Oracle.VirtualBox -e

REM pause the script to see the output
pause