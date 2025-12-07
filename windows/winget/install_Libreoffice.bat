@echo off

REM -e ensures an exact match for the package ID 
echo Installing LibreOffice...
winget install --id TheDocumentFoundation.LibreOffice -e

REM pause the script to see the output
pause