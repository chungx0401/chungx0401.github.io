@ECHO OFF
ECHO //////////////////////////
ECHO // Checking Environment //
ECHO //////////////////////////
ECHO:
CALL gem environment
ECHO:
CALL bundle version
ECHO:
ECHO ///////////////////////////////////
ECHO // Running Local Test for Jekyll //
ECHO ///////////////////////////////////
ECHO:
CALL bundle exec jekyll serve