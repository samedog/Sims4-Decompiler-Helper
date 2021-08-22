@echo off
rem Based on darkittens's script
rem this batch uses 3 decompilers for max reliability

rem Setting up Versions

set pyminver=3.7.0
set dcminver=3.7.6
set ucminver=3.7.4

FOR /F "tokens=* USEBACKQ" %%F IN (`python.exe --version`) DO (SET py3=%%F)
set "py3=%py3:* =%"

FOR /F "tokens=* USEBACKQ" %%F IN (`decompyle3.exe --version`) DO (SET dcp3=%%F)
set "dcp3=%dcp3:* =%"

FOR /F "tokens=* USEBACKQ" %%F IN (`uncompyle6.exe --version`) DO (SET ucp6=%%F)
set "ucp6=%ucp6:* =%"

rem version check now in a function (tm)
CALL :VersionCheck python %py3% %pyminver%
CALL :VersionCheck decompyle3 %dcp3% %dcminver%
CALL :VersionCheck uncompyle6 %ucp6% %ucminver%
CALL :VersionCheck unpyc3 1 1

rem Decompile Stuff

echo Go get yourself some coffee, and wait awhile, all 3 zip's used for code take forever to 
echo decompile, so its going to take a bit.  Enjoy!

echo Setting Directories...
set SIMS4DIR=GAME_DIR
set TEMPDIR=TEMP_DIR_FOR_PROCESSING
set ZIPPROGRAM=C:\Program Files\7-Zip\7z.exe
set set UNPYC=PAH_TO_unpyc3.py

Call :CleanUp 1

rem Main loop calls
CALL :MainLoopFunction "base.zip"
CALL :MainLoopFunction "core.zip"
CALL :MainLoopFunction "simulation.zip"

echo Done ... press any key to continue
pause

rem *********************************************************************************************************
:MainLoopFunction
	set zipname=%~1
	echo "Creating %TEMPDIR%"
	mkdir "%TEMPDIR%"
	echo "entering main function with %zipname%"
	echo "Copying %zipname% to temp folder at %TEMPDIR%"
	copy "%SIMS4DIR%\Data\Simulation\Gameplay\%zipname%" "%TEMPDIR%"
	
	
	if %zipname% == base.zip (
		set FOLDERNAME="base"
		rem set ZIPPATH="libs\lib"
		rem set FINALZIPNAME="base-src.zip"
		rem set KEYLOCATION="%FOLDERNAME%\key"
	)
	if %zipname% == core.zip (
		set FOLDERNAME=core
		rem set ZIPPATH=core
		rem set FINALZIPNAME="core-src.zip"
		rem set KEYLOCATION=key
	)
	if %zipname% == simulation.zip (
		set FOLDERNAME="simulation"
		rem set ZIPPATH="simulation"
		rem set FINALZIPNAME="simulation-src.zip"
		rem set KEYLOCATION="key"
	)
	
	"%ZIPPROGRAM%" x "%TEMPDIR%\%zipname%" -o"%TEMPDIR%\%FOLDERNAME%"

	if exist "%TEMPDIR%\%zipname%" (
		echo "Deleting Old %zipname%"
		del "%TEMPDIR%\%zipname%"
		echo Done
	)
	
	set TD="%TEMPDIR%\%FOLDERNAME%"
	echo Decompiling %TD% and all subfolder PYC files (Warning Not all Files will Decompile properly) Press any key to start.
	
	CALL :DecompilerLoop %TD%

	echo Removing pyc files
	del /s %TD%\*.pyc

	rem echo Zipping %folder_name% folder
	rem "%ZIPPROGRAM%" a %FINALZIPNAME% "%TEMPDIR%\%KEYLOCATION%" "%TEMPDIR%\%ZIPPATH%"
	echo Moving folder to tree root
	move "%TEMPDIR%\%FOLDERNAME%" "%FOLDERNAME%"
	
	echo Deleting temporal Files and Folders
	Call :CleanUp 0
EXIT /B 0

rem this loops iterates over files and tries to decompile all pyc
rem i use decompyle3 as main, uncompyle6 as backup and unpyc3 as last resort
rem (reliability over performance)
:DecompilerLoop
	set pypath="%~1"
	for /R %pypath% %%f in (*.pyc) do ( 
		echo "****************************************************************************************************"
		echo "Decompiling %%~pf%%~nf.pyc"
		decompyle3 -o "%%~df%%~pf%%~nf.py" "%%~df%%~pf%%~nf.pyc" | find "Successfully decompiled file"
		if errorlevel 1 ( 
			echo "could not decompile file with decompyle3, trying uncompyle6"
			uncompyle6 -o "%%~df%%~pf%%~nf.py" "%%~df%%~pf%%~nf.pyc" | find "Successfully decompiled file"
			if errorlevel 1 ( 
				echo "=============================================================================="
				echo "could not decompile trying unpyc3 as last resort"
				echo "cross your fingers and check the file manually"
				echo "%%~pf%%~nf.py"
				echo "=============================================================================="
				python.exe "%UNPYC%" "%%~df%%~pf%%~nf.pyc" > "%%~df%%~pf%%~nf.py"
				if %%~z%%~df%%~pf%%~nf.py == 0  (
					echo "could not decompile with uncompyle6 or deompyle3 or unpyc3"
				) else (
					echo # Successfully decompiled file
					echo "%%~pf%%~nf.pyc with unpyc3"
				)
			) else ( 
				echo "%%~pf%%~nf.pyc with uncompyle6"
			)
		) else ( 
			echo "%%~pf%%~nf.pyc with decompyle3"	
		)
	)
EXIT /B 0

:VersionCheck
	set program="%~1"
	set cur_ver="%~2"
	set min_ver="%~3"
	set ucp_flag=0
	set unpyc3_flag=0
	echo -----------------------------------------------
	echo Checking %program% Version
	
	if %program% == "python" ( set extra_steps="Please install Python 3.7 from the Microsoft store or thru conda" )
	if %program% == "decompyle3" ( set extra_steps="Please install decompyle 3 from https://github.com/rocky/python-decompile3" )
	if %program% == "uncompyle6" ( set ucp_flag=1 )
	if %program% == "unpyc3" ( set unpyc3_flag=1 )
	
	if "%unpyc3_flag%" geq "%min_ver%" (
		if exist "unpyc3.py" (
			echo unpyc3 is installed.
		) else (
			bitsadmin.exe /transfer "unpyc3" "https://raw.githubusercontent.com/andrew-tavera/unpyc37/master/unpyc3.py" "%~dp0\unpyc3.py"
		)
	) else (
		if "%cur_ver%" geq "%min_ver%" (
			echo %program% version: %cur_ver% is correct
		) else (
			echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
			echo "you do not have the correct version: %min_ver%"
			if %ucp_flag% geq 1 (
				echo Installing uncompyle6  
				pip install uncompyle6
				echo Done...
			) else (
				echo %extra_steps%
			)
			echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
			exit
		)
	)
	echo:
EXIT /B 0

:CleanUp
	set initflag=%~1
	
	if %initflag% geq 1 (
		CALL :DeleteSafe temp
		CALL :DeleteSafe base
		CALL :DeleteSafe core
	)
	CALL :DeleteSafe simulation
EXIT /B 0

:DeleteSafe
	set folder=%~1
	echo Checking if your simulation dir exists at %folder%
	if exist "%folder%" (
		echo File exists
		del /f /q "%folder%"
	)
	if exist "%folder%" (
		echo Folder exists
		rmdir /q /s "%folder%"
	)
EXIT /B 0
