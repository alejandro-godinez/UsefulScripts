@echo off

REM -e ensures an exact match for the package ID 
echo Installing TortoiseGit...
winget install --id TortoiseGit.TortoiseGit -e

REM pause the script to see the output
pause