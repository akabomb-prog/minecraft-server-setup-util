@ECHO OFF

TITLE Minecraft Server Setup Utility

SET VERSIONS_FILE=versions.txt
ECHO Initializing versions... (reading %VERSIONS_FILE%)

REM Simply putting it as "1.14.4", for example, will not work.
REM Not sure why. You HAVE to have a letter in there. (i.e. "v1.14.4")
SET I=0
FOR /F "delims=" %%x IN (%VERSIONS_FILE%) DO (
	SET "v%%x"
	SET /A I+=1
)

ECHO %I% version(s) loaded!
ECHO.

SET JAVA_EXISTS=0
IF EXIST "%JAVA_HOME%\bin\java.exe" SET JAVA_EXISTS=1
WHERE java > NUL
IF %ERRORLEVEL%==0 SET JAVA_EXISTS=1

IF %JAVA_EXISTS%==0 CALL :JAVA_NOT_FOUND

ECHO Welcome to the Minecraft Server Setup Utility.

GOTO :A

:A

CALL :NAME
IF EXIST "%NAME%\" GOTO :DIR_EXISTS
GOTO :B
:B

IF NOT EXIST "%NAME%" MKDIR "%NAME%"
CD "%NAME%"

CALL :CHOOSE_VERSION
CALL SET "OBJ=%%v%VERSION%%%"

IF "%OBJ%"=="" GOTO :NO_SUCH_VERSION
GOTO :C
:C

ECHO Downloading server.jar for %VERSION%.
ECHO Download URL: %OBJ%

IF EXIST "server.jar" GOTO :SERVER_JAR_ALREADY_PRESENT

curl "%OBJ%" --output server.jar
IF NOT EXIST server.jar GOTO :SERVER_JAR_NOT_PRESENT

GOTO :D
:D

IF NOT EXIST "../files" GOTO :DONE
ECHO Copying additional files.
ROBOCOPY ../files .
IF NOT %ERRORLEVEL%==3 GOTO :COPY_ERROR

GOTO :DONE
:DONE

ECHO The Minecraft Server Setup Utility has completed the setup of %NAME% running on %VERSION%.
ECHO Press any key to exit.
PAUSE > NUL
GOTO :EXIT

:JAVA_NOT_FOUND
	ECHO.
	ECHO WARNING: java.exe was not found in %%JAVA_HOME%% or %%PATH%%.
	ECHO.
	EXIT /B

:CHOOSE_VERSION
	SET /P VERSION=Server version: 
	EXIT /B
:NO_SUCH_VERSION
	ECHO No such version, "%VERSION%", exists in %VERSIONS_FILE%.
	ECHO Check for errors or update config.
	GOTO :B
:NAME
	SET /P NAME=Server folder name: 
	EXIT /B
:DIR_EXISTS
	ECHO The directory "%NAME%" already exists.
	CHOICE /N /M "Use directory anyway? [Y/N]"
	IF %ERRORLEVEL%==2 GOTO :A
	GOTO :B

:SERVER_JAR_NOT_PRESENT
	ECHO server.jar does not seem to be present after presumed download.
	CHOICE /N /M "Try downloading again? [Y/N]"
	IF %ERRORLEVEL%==1 GOTO :C
	ECHO Server setup may not continue without server.jar.
	ECHO Press any key to exit.
	PAUSE > NUL
	GOTO :EXIT
:SERVER_JAR_ALREADY_PRESENT
	ECHO server.jar seems to be already present before download.
	CHOICE /N /M "Skip download? [Y/N]"
	IF %ERRORLEVEL%==1 GOTO :C
	GOTO :D

:COPY_ERROR
	ECHO There was an error copying files using robocopy.
	ECHO Error code: %ERRORLEVEL%
	ECHO.
	CHOICE /N /M "Try again? [Y/N]"
	IF %ERRORLEVEL%==0 GOTO :D
	GOTO :DONE

:EXIT
	ENDLOCAL
	EXIT /B
