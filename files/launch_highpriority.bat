@ECHO OFF
:A
START /B /HIGH /WAIT "" "java" -Xmx1G -Xms1G -jar server.jar nogui
CHOICE /N /M "Server closed. Restart? [Y/N]"
IF %ERRORLEVEL%==1 GOTO :A
EXIT /B