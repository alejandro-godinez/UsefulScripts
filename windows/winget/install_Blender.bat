@echo off

REM -e ensures an exact match for the package ID 
echo Installing Blender...
winget install --id BlenderFoundation.Blender -e

REM pause the script to see the output
pause