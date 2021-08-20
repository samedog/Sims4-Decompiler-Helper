@echo off
rem Batch file created by Darkkitten on 9/2/2014 at 9pm PST
rem Batch file was updated by Darkkitten on 2/22/2019 at 5:20 CST
rem Batch file modded by the_samedog on 08/22/2021 at 10:19 GMT-4

rem Setting up Versions
set py_minver=3.7.0
set dc_minver=3.7.6
set uc_minver=3.7.4

FOR /F "tokens=* USEBACKQ" %%F IN (`python.exe --version`) DO (SET py3=%%F)
set "py3=%py3:* =%"

FOR /F "tokens=* USEBACKQ" %%F IN (`decompyle3.exe --version`) DO (SET dcp3=%%F)
set "dcp3=%dcp3:* =%"

FOR /F "tokens=* USEBACKQ" %%F IN (`uncompyle6.exe --version`) DO (SET ucp6=%%F)
set "ucp6=%ucp6:* =%"

rem version check now in a function (tm)
CALL :VersionCheck python %py3% %py_minver%
CALL :VersionCheck decompyle3 %dcp3% %dc_minver%
CALL :VersionCheck uncompyle6 %ucp6% %uc_minver%


rem Decompile Stuff

echo Go get yourself some coffee, and wait awhile, all 3 zip's used for code take forever to 
echo decompile, so its going to take a bit.  Enjoy!

echo Setting Directories...
set SIMS4DIR=C:\Games\The Sims 4
set TEMPDIR=C:\Users\demon\Documents\SIMS4 MODS\Forex ^& Investments\Temp
set ZIPPROGRAM=C:\Program Files\7-Zip\7z.exe
set UNPYC=C:\Users\demon\Documents\SIMS4 MODS\Forex ^& Investments\unpyc3.py

echo "Checking if your Temp dir exists at %TEMPDIR%"

if exist "%TEMPDIR%" (
	echo Folder exists
) else (
	echo "Creating %TEMPDIR%"
	mkdir "%TEMPDIR%"
	echo Done
	pause
)


rem Main loop calls
CALL :MainLoopFunction "base.zip"
CALL :MainLoopFunction "core.zip"
CALL :MainLoopFunction "simulation.zip"

echo Done ... press any key to continue
pause


rem *********************************************************************************************************
:MainLoopFunction
	set zipname=%~1
	echo "entering main function with %zipname%"
	echo "Copying %zipname% to temp folder at %TEMPDIR%"
	copy "%SIMS4DIR%\Data\Simulation\Gameplay\%zipname%" "%TEMPDIR%"

	if %zipname% == base.zip (
		set folder_name = "libs"
		set zip_name = "libs\lib"
	)
	if %zipname% == core.zip (
		set folder_name = "core"
		set zip_name = %folder_name%
	)
	if %zipname% == simulation.zip (
		set folder_name = "simulation"
		set zip_name = %folder_name%
	)

	"%ZIPPROGRAM%" x "%TEMPDIR%\%zipname%" -o"%TEMPDIR%\%folder_name%"

	if exist "%TEMPDIR%\%zipname%" (
		echo "Deleting Old %zipname%"
		del "%TEMPDIR%\%zipname%"
		echo Done
	)
	
	set TD="%TEMPDIR%\%folder_name%"

	echo Decompiling %TD% and all subfolder PYC files (Warning Not all Files will Decompile properly) Press any key to start.
	pause

	CALL :DecompilerLoop %TD%

	echo Done ... press any key to continue
	pause

	echo Removing pyc files
	del /s %TD%\*.pyc

	echo Zipping %folder_name% folder
	"%ZIPPROGRAM%" a base-src.zip "%TEMPDIR%\libs\key" "%TEMPDIR%\%zip_name%"

	echo Deleting Files and Folders
	rmdir /s /q "%TEMPDIR%\%folder_name%"

	echo Done.. Press any Key to continue
	pause


rem this loops iterates over files and tries to decompile all pyc
rem i use decompyle3 as main, uncompyle6 as backup and unpyc3 as last resort
rem (reliability over performance)
:DecompilerLoop
	set pypath="%~1"
	for /R %pypath% %%f in (*.pyc) do ( 
		echo "****************************************************************************************************"
		echo "Decompiling %%~df%%~pf%%~nf.pyc"
		decompyle3 -o "%%~df%%~pf%%~nf.py" "%%~df%%~pf%%~nf.pyc" | find "Successfully decompiled file"
		if errorlevel 1 ( 
			echo "could not decompile file with decompyle3, trying uncompyle6"
			uncompyle6 -o "%%~df%%~pf%%~nf.py" "%%~df%%~pf%%~nf.pyc" | find "Successfully decompiled file"
			if errorlevel 1 ( 
				echo "=============================================================================="
				echo "could not decompile trying unpyc3 as last resort"
				echo "cross your fingers and check the file manually"
				echo "%%~df%%~pf%%~nf.py"
				echo "=============================================================================="
				python.exe "%UNPYC%" "%%~df%%~pf%%~nf.pyc" > "%%~df%%~pf%%~nf.py"
				if %%~z%%~df%%~pf%%~nf.py == 0  (
					echo "could not decompile with uncompyle6 or deompyle3 or unpyc3"
				) else (
					echo # Successfully decompiled file
					echo "%%~df%%~pf%%~nf.pyc with unpyc3"
				)
			) else ( 
				echo "%%~df%%~pf%%~nf.pyc with uncompyle6"
			)
		) else ( 
			echo "%%~df%%~pf%%~nf.pyc with decompyle3"	
		)
	)


:VersionCheck
	set program="%~1"
	set cur_ver="%~2"
	set min_ver="%~3"
	set ucp_flag=0
	echo -----------------------------------------------
	echo Checking %program% Version
	
	if %program% == "python" ( set extra_steps="Please install Python 3.7 from the Microsoft store or thru conda" )
	if %program% == "decompyle3" ( set extra_steps="Please install decompyle 3 from https://github.com/rocky/python-decompile3" )
	if %program% == "uncompyle6" ( set ucp_flag=1	)
	

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
	echo:
	
