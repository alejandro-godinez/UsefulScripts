@echo off

REM -e ensures an exact match for the package ID 
echo Installing HandBrake...
winget install --id HandBrake.HandBrake -e

REM pause the script to see the output
pause