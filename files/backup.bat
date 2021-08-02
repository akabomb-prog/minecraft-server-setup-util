@ECHO OFF
SET /P WORLD=World name (world): 
IF "%WORLD%"=="" SET WORLD=world
SET CURTIMEDATE=%time:~0,2%%time:~3,2%%time:~6,2%_%date:~-10,2%%date:~-7,2%%date:~-4,4%
IF NOT EXIST backup GOTO :NOBACKUP
GOTO :DOBACKUP

:NOBACKUP
	MKDIR backup
	GOTO :DOBACKUP

:DOBACKUP
	ECHO Will back up world "%world%" to backup\%CURTIMEDATE%.
	TIMEOUT 1 > NUL
	XCOPY /E /I "%world%" "backup\%CURTIMEDATE%\%world%"
	XCOPY /E /I "%world%_nether" "backup\%CURTIMEDATE%\%world%_nether"
	XCOPY /E /I "%world%_the_end" "backup\%CURTIMEDATE%\%world%_the_end"
	ECHO World %world% was backed up at backup\%CURTIMEDATE%.
	ECHO Press any key to exit.
	PAUSE > NUL
	EXIT /B