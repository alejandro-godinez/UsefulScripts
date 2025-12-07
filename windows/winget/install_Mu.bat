@echo off

REM -e ensures an exact match for the package ID 
echo Installing Mu Editor...
winget install --id Mu.Mu -e

REM pause the script to see the output
pause