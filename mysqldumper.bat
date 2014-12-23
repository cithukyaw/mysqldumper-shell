@ECHO off
SETLOCAL EnableDelayedExpansion

:: Set variables
:: path to your mysql.exe installation path
SET mysqlDir=D:\xampp\mysql\bin
:: Store mysql login information in a file e.g., c:\users\[username]\mysqldumper.cnf with your mysql information
::
::    [client]
::    host=your_host
::    user=your_username
::    password=your_password
::
:: To keep the password safe, the file should not be accessible to anyone but yourself.
:: To ensure this, set the file access mode to 400 or 600, e.g., chmod 600 [the-file]
:: @see http://dev.mysql.com/doc/refman/5.5/en/password-security-user.html
:: Set the fully qualified path name to the file here
SET mysqlLogin=%UserProfile%\mysqldumper.cnf
:: The directory where you want to save your sql files
:: It will be created if it does not exist
SET backupDir=%UserProfile%\.mysqlbackup
:: The system databases which don't need to be dumped
SET dbsIgnored=information_schema,cdcol,mysql,performance_schema,phpmyadmin,test,webauth,
:: Temp file
SET tmpFile=%TEMP%\mysqldbs.tmp

SET paramName=
SET dbs=
:argLoopStart
	SET arg=%1
	IF -!arg!-==-- GOTO argLoopEnd
	IF %arg:~0,2%==-- (
		SET paramName=!arg!
	) ELSE (
		IF "!paramName!" == "--dbs" ( SET dbs=!dbs!%arg% )
	)
	SHIFT
	GOTO argLoopStart
:argLoopEnd

:errorHandling
	IF NOT EXIST %mysqlLogin% ( GOTO errConfig )
	IF NOT EXIST %mysqlDir% ( GOTO errDir )
	GOTO main

:errConfig
	ECHO ERROR^^! at line 18 in mysqldumper.bat
	ECHO Configuration needed. Store mysql login information in a file 
	ECHO e.g., %UserProfile%\mysqldumper.cnf with your mysql information
	ECHO\
	ECHO    [client]
	ECHO    host=your_host
	ECHO    user=your_username
	ECHO    password=your_password
	ECHO\
	ECHO To keep the password safe, the file should not be accessible to anyone but yourself.
	ECHO To ensure this, set the file access mode to 400 or 600, e.g., chmod 600 [the-file]
	ECHO @see http://dev.mysql.com/doc/refman/5.5/en/password-security-user.html
	GOTO end

:errDir
	ECHO ERROR^^! at line 6 in mysqldumper.bat
	ECHO Set the directory path where your mysql.exe was installed
	GOTO end
	
:main
	:: Get the current Date and Time in a locale-agnostic way
	FOR /f "skip=1" %%x IN ('wmic os get localdatetime') DO (
		IF NOT DEFINED timestamp SET timestamp=%%x
	)
	SET today=%timestamp:~0,4%%timestamp:~4,2%%timestamp:~6,2%
	SET time24=%timestamp:~8,2%%timestamp:~10,2%%timestamp:~12,2%

	:: check the backup directory
	IF NOT EXIST %backupDir% (
		MD %backupDir%
		ECHO %backupDir% is created.
	)

	:: Change to mysql dir
	CD !mysqlDir!

	IF "!dbs!"=="" (
		REM Get all databases name into a temp file
		REM If the server was started with the --skip-show-database option,
		REM you cannot use this statement at all unless you have the SHOW DATABASES privilege.
		mysql --defaults-extra-file=!mysqlLogin! -e "SHOW DATABASES" > "!tmpFile!"

		REM Process all database names in the file
		FOR /F "delims=\ tokens=* skip=1" %%L IN (!tmpFile!) DO (
			REM Skip if the database is in the ignored list
			IF "!dbsIgnored:%%L,=!" EQU "!dbsIgnored!" (
				ECHO Dumping %%L ...
				mysqldump --defaults-extra-file=!mysqlLogin! --quick --opt --add-drop-database --databases %%L > !backupDir!\%%L_!today!.sql
				ECHO Exported !backupDir!\%%L_!today!.sql
			)
		)
	) ELSE (
		:: Dumping the given databases only
		FOR %%L IN (!dbs!) DO (
			ECHO Dumping %%L ...
			mysqldump --defaults-extra-file=!mysqlLogin! --quick --opt --add-drop-database --databases %%L > !backupDir!\%%L_!today!.sql
			ECHO Exported !backupDir!\%%L_!today!.sql
		)
	)

	:done
		ECHO Done^^!

	:end
		:: Delete the temporary file
		IF EXIST !tmpFile! ( DEL !tmpFile! )
		:: Go back to the original directory to the script
		CD %~dp0
ENDLOCAL
