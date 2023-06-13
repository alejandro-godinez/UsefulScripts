#!/bin/bash

# -----------------------------------------------------------------------------------
# This program installs a java project to your local maven repository.  
# 
# version: 2022.04.07
# -----------------------------------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

#define project maven variables (build project prior)
projVersion="1.0.0.0"
projName=""
artifactId=""
groupId=""

#//check if project is installed in user's home maven repo
mvnPath=~/.m2/repository/${groupId}/${artifactId}/${projVersion}/
if [ -d "${mvnPath}" ]; then
  echo -e "${GREEN}${projName} v${projVersion} Already Installed${NC}"
else
  echo -e "${RED}${projName} v${projVersion} Not Installed${NC}"
fi

#//check with user if they want to intall the project
jarFile="release/${projVersion}/${projName}-${projVersion}.jar"
echo -n "Do you want to install ${projName}.jar v${projVersion}? (y/yes): "
read doInstall
if [[ ${doInstall} =~ ^([y]|yes|YES)$ ]]
then
  
  #//install project to maven
  echo "Installing ${projName} to maven..."
  mvn install:install-file \
  -Dfile=${jarFile} \
  -DgroupId=${groupId} \
  -DartifactId=${artifactId} \
  -Dversion=${projVersion} \
  -Dpackaging=jar \
  -DgeneratePom=true
  
else
  echo "${projName} install skipped." 
fi

