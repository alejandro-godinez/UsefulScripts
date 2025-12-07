@echo off

REM -e ensures an exact match for the package ID 
echo Installing KeePass...
winget install --id DominikReichl.KeePass -e

REM pause the script to see the output
pause