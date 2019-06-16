:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: The simple and quick MySQL database backup batch script.
:: It dumps all databases into a directory specified. It exports .sql file
:: for each database with the file name format of <db_name>_<YYYYMMDD>.sql
::
:: Licensed under The MIT License
:: For full copyright and license information, please see LICENSE
::
:: @author     Sithu Kyaw <hello@sithukyaw.com>
:: @license    http://www.opensource.org/licenses/mit-license.php MIT License
::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@ECHO off
SETLOCAL EnableDelayedExpansion

REM Set variables
REM path to your mysql.exe installation path
SET mysqlDir=D:\xampp\mysql\bin
REM Store mysql login information in a file e.g., C:\Users\[username]\.my.cnf with your mysql information
REM
REM    [client]
REM    host=your_host
REM    user=your_username
REM    password=your_password
REM
REM To keep the password safe, the file should not be accessible to anyone but yourself.
REM To ensure this, set the file access mode to 400 or 600, e.g., chmod 600 [the-file]
REM @see http://dev.mysql.com/doc/refman/5.5/en/password-security-user.html
REM Set the fully qualified path name to the file here
SET mysqlLogin=%UserProfile%\.my.cnf
REM The directory where you want to save your sql files
REM It will be created if it does not exist
SET backupDir=%UserProfile%\.mysqlbackup
REM The system databases which don't need to be dumped
REM Please make sure to include the trailing comma if you update this list
SET dbsIgnored=information_schema,cdcol,mysql,performance_schema,phpmyadmin,test,webauth,
REM Temp file
SET tmpFile=%TEMP%\mysqldbs.tmp

REM Argument capturing
SET paramName=
SET dbs=
:argLoopStart
	SET arg=%1
	IF -!arg!-==-- GOTO argLoopEnd
	REM long parameter name such as --argument
	IF %arg:~0,2%==-- (
		SET paramName=!arg!
	) ELSE (
		IF "!paramName!" == "--dbs" ( SET dbs=!dbs!%arg% )
	)
	REM short parmeter name such as -a
	IF %arg:~0,1%==- (
		SET paramName=!arg!
	) ELSE (
		IF "!paramName!" == "-d" ( SET dbs=!dbs!%arg% )
	)
	SHIFT
	GOTO argLoopStart
:argLoopEnd

:errorHandling
	IF NOT EXIST %mysqlLogin% ( GOTO errConfig )
	IF NOT EXIST %mysqlDir% ( GOTO errDir )
	GOTO main

:errConfig
	(ECHO [client] & ECHO host=localhost & ECHO user=root & ECHO password=) > %mysqlLogin%
	ECHO NOTICE^^! at line 32 in mysqldumper.bat
	ECHO Configuration file %mysqlLogin% has been created.
	ECHO Update your mysql login information in the file as below
	ECHO.
	ECHO    [client]
	ECHO    host=your_host
	ECHO    user=your_username
	ECHO    password=your_password
	ECHO.
	ECHO To keep the password safe, the file should not be accessible to anyone but yourself.
	ECHO To ensure this, set the file access mode to 400 or 600, e.g., chmod 600 [the-file]
	ECHO @see http://dev.mysql.com/doc/refman/5.5/en/password-security-user.html
	GOTO end

:errDir
	ECHO ERROR^^! at line 20 in mysqldumper.bat
	ECHO Set the directory path where your mysql.exe was installed
	GOTO end

:main
	REM Get the current Date and Time in a locale-agnostic way
	FOR /f "skip=1" %%x IN ('wmic os get localdatetime') DO (
		IF NOT DEFINED timestamp SET timestamp=%%x
	)
	SET today=%timestamp:~0,4%%timestamp:~4,2%%timestamp:~6,2%
	SET time24=%timestamp:~8,2%%timestamp:~10,2%%timestamp:~12,2%

	SET backupDir=%backupDir%\%today%

	REM check the backup directory
	IF NOT EXIST %backupDir% (
		MD %backupDir%
		ECHO %backupDir% is created.
	)

	REM Change to mysql dir
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
		REM Dumping the given databases only
		FOR %%L IN (!dbs!) DO (
			ECHO Dumping %%L ...
			mysqldump --defaults-extra-file=!mysqlLogin! --quick --opt --add-drop-database --databases %%L > !backupDir!\%%L_!today!.sql
			ECHO Exported !backupDir!\%%L_!today!.sql
		)
	)

	:done
		ECHO Done^^!

	:end
		REM Delete the temporary file
		IF EXIST !tmpFile! ( DEL !tmpFile! )
		REM Go back to the original directory to the script
		CD %~dp0
ENDLOCAL
