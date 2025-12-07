@echo off

REM -e ensures an exact match for the package ID 
echo Installing Notepad++...
winget install --id Notepad++.Notepad++ -e

REM pause the script to see the output
pause
