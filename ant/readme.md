build_junit.xml
  This is a re-usable ANT build script that will also execute all the 
  JUnit tests in the project and halt the build if there are any
  failures.
  
  Dependencies: Include the following jar files in the project lib folder
    junit-4.11.jar
    ant-junit-1.8.1.jar