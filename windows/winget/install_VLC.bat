@echo off

REM -e ensures an exact match for the package ID 
echo Installing VLC...
winget install --id VideoLAN.VLC -e

REM pause the script to see the output
pause