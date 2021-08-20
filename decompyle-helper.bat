@rem Batch file created by Darkkitten on 9/2/2014 at 9pm PST
@rem Batch file was updated by Darkkitten on 2/22/2019 at 5:20 CST
@rem
@rem Version 8.1
@rem 
@rem You will need Python 3.7.11  make sure you click the check box next to the add python to path
@rem decompyle3 now automatily installs for you.
@rem 
@rem Did some cleanup added the latest patch to decompile
@rem Fixed up some folder errors.
@rem I still need to work on getting the decompyle3 version check working right.
@rem Now checks if your tempdir exists and if not creates it instead of just doing a mkdir.
@rem I will only maintain this on major change updates now.
@rem I no longer need to update for Patch Versions with 8.1.
@rem If you find any issues email me @ darkkitten at gmail dot com
@rem 
@rem Bat file to decompile TS4 Python code
@rem Set your Sims4 Directory here
@rem Set your tempdir here as well
@rem Also Set your Zip Program

@rem Setting up Versions
@if not defined python (set py3=3.7.11)
@if not defined decompyle3 (set dcp3=3.2.5)

@rem Python
@echo Checking Python Version
@rem @if %py3% geq 3.7.11( @goto Finish ) else ( @goto NoPython )
@if %py3% geq 3.7.11( @goto NoPython ) else ( @goto NoPython )

@:Finish
@python --version
@echo You have the correct version of python.
@echo Cecking decompyle3 Version
@if %dcp3% geq 3.5.2 ( @goto Finish2 ) else ( @goto Installdecompyle3 )

@rem decompyle3
@:Finish2
@echo You have the current version of decompyle3 installed.
@decompyle3 --version
@goto Finish3

@rem Decompile Stuff
@:Finish3

@echo Go get yourself some coffee, and wait awhile, all 3 zip's used for code take forever to 
@echo decompile, so its going to take a bit.  Enjoy!

@echo Setting Directories...
@set SIMS4DIR="GAME_DIR"
@set TEMPDIR="TEMP_DIR_FOR_PROCESSING"
@set ZIPPROGRAM="C:\Program Files\7-Zip\7z.exe"

@echo Checking if your Temp dir exists at %TEMPDIR%
@if exist %TEMPDIR% (@goto Continue2) else  (@goto Createfolder)

@:Continue1

@echo Copying base.zip to temp folder at "%TEMPDIR%"
@copy %SIMS4DIR%\Data\Simulation\Gameplay\base.zip %TEMPDIR%

@%ZIPPROGRAM% x %TEMPDIR%\base.zip -o%TEMPDIR%\libs

@echo Deleting Old Base zip
@del %TEMPDIR%\base.zip
@echo Done

@set TD=%TEMPDIR%\libs

@echo Decompiling %TD% and all subfolder PYC files  (Warning Not all Files will Decompile properly) Press any key to start.
@pause
@echo off

@for /R %TD% %%f in (*.pyc) do ( 
	decompyle3 -o "%%~df%%~pf%%~nf.py" "%%~df%%~pf%%~nf.pyc" | find "Successfully decompiled file"
	if errorlevel 1 ( 
		echo "could not decompile file with decompile3, trying uncompyle6"
		uncompyle6 -o "%%~df%%~pf%%~nf.py" "%%~df%%~pf%%~nf.pyc" | find "Successfully decompiled file"
			if errorlevel 1 ( 
				echo "=============================================================================="
				echo "could not decompile with uncompyle6 or deompyle3, trying unpyc3 as last resort"
				echo "cross your fingers and check the file manually"
				echo "%%~df%%~pf%%~nf.py"
				echo "=============================================================================="
				python.exe unpyc3.py "%%~df%%~pf%%~nf.pyc" > "%%~df%%~pf%%~nf.py"
			)  else ( 
				echo "%%~df%%~pf%%~nf.pyc with uncompyle6"
			)
		) else ( 
		echo "%%~df%%~pf%%~nf.pyc with decompyle3"	
	)
)

@REM Finished with base conversions
@echo Done ... press any key to continue
@pause

@echo Removing pyc files
@del /s %TD%\*.pyc

@echo Zipping base folder
@%ZIPPROGRAM% a base-src.zip  %TEMPDIR%\libs\key %TEMPDIR%\libs\lib

@echo Deleting Files and Folders
@rmdir /s /q %TEMPDIR%\libs

@echo Done.. Press any Key to continue
@pause

@rem Core.zip
@echo Copying core.zip to temp folder at "%TEMPDIR%"
@copy %SIMS4DIR%\Data\Simulation\Gameplay\core.zip %TEMPDIR%

@%ZIPPROGRAM% x %TEMPDIR%\core.zip -o%TEMPDIR%\core
@echo Deleting core.zip
@del %TEMPDIR%\core.zip
@echo Done

@set TD=%TEMPDIR%\core

@echo Decompiling %TD% and sub folders pyc files  (Warning Not all Files will Decompile properly) Press any key to start.
@pause
@echo off

@for /R %TD% %%f in (*.pyc) do ( 
	decompyle3 -o "%%~df%%~pf%%~nf.py" "%%~df%%~pf%%~nf.pyc" | find "Successfully decompiled file"
	if errorlevel 1 ( 
		echo "could not decompile file with decompile3, trying uncompyle6"
		uncompyle6 -o "%%~df%%~pf%%~nf.py" "%%~df%%~pf%%~nf.pyc" | find "Successfully decompiled file"
			if errorlevel 1 ( 
				echo "=============================================================================="
				echo "could not decompile with uncompyle6 or deompyle3, trying unpyc3 as last resort"
				echo "cross your fingers and check the file manually"
				echo "%%~df%%~pf%%~nf.py"
				echo "=============================================================================="
				python.exe unpyc3.py "%%~df%%~pf%%~nf.pyc" > "%%~df%%~pf%%~nf.py"
			)  else ( 
				echo "%%~df%%~pf%%~nf.pyc with uncompyle6"
			)
		) else ( 
		echo "%%~df%%~pf%%~nf.pyc with decompyle3"	
	)
)


@rem Finished with Core conversions
@echo Done ... press any key to continue
@pause

@echo Removing pyc files
@del /s %TD%\*.pyc

@echo Zipping Files
@%ZIPPROGRAM% a core_src.zip %TEMPDIR%\key %TEMPDIR%\core

@echo Cleaning up %TEMPDIR%
@rmdir /s /q %TEMPDIR%\core

@echo Done ... press any key to continue
@pause

@rem Simulation.zip
@echo Copying simulation.zip to temp folder at "%TEMPDIR%"
@copy %SIMS4DIR%\Data\Simulation\Gameplay\simulation.zip %TEMPDIR%
@cd %TEMPDIR%

@%ZIPPROGRAM% x %TEMPDIR%\simulation.zip -o%TEMPDIR%\simulation
@echo Deleting simulation.zip

@del %TEMPDIR%\simulation.zip
@echo Done

@set TD=%TEMPDIR%\simulation

@echo Decompiling Simulation and sub folders pyc files  (Warning Not all Files will Decompile properly) Press any key to start.
@pause
@echo off

@for /R %TD% %%f in (*.pyc) do ( 
	decompyle3 -o "%%~df%%~pf%%~nf.py" "%%~df%%~pf%%~nf.pyc" | find "Successfully decompiled file"
	if errorlevel 1 ( 
		echo "could not decompile file with decompile3, trying uncompyle6"
		uncompyle6 -o "%%~df%%~pf%%~nf.py" "%%~df%%~pf%%~nf.pyc" | find "Successfully decompiled file"
			if errorlevel 1 ( 
				echo "=============================================================================="
				echo "could not decompile with uncompyle6 or deompyle3, trying unpyc3 as last resort"
				echo "cross your fingers and check the file manually"
				echo "%%~df%%~pf%%~nf.py"
				echo "=============================================================================="
				python.exe unpyc3.py "%%~df%%~pf%%~nf.pyc" > "%%~df%%~pf%%~nf.py"
			)  else ( 
				echo "%%~df%%~pf%%~nf.pyc with uncompyle6"
			)
		) else ( 
		echo "%%~df%%~pf%%~nf.pyc with decompyle3"	
	)
)

@REM Finished with Simulation conversions
@echo Done ... press any key to continue
@pause

@echo Deleting pyc Files
@del /s %TD%\*.pyc

@echo Compressing simulation
@%ZIPPROGRAM% a simulation-src.zip %TEMPDIR%\key %TEMPDIR%\simulation

@echo Cleaning up %TEMPDIR%
@del %TEMPDIR%\key
@rmdir /s /q %TEMPDIR%\simulation
@goto FinalDone


@:Createfolder
@echo Creating %TEMPDIR%
mkdir %TEMPDIR%
@echo Done
@pause
@goto Continue1

@:NoPython
@echo you do not have the correct version of python. Please install 3.7.11


@:Installdecompyle3
@echo Installing decompyle3
@pip install decompyle3
@echo Done...
@pause
@goto Finish2

@:Continue2
@echo Folder exists
@goto Continue1

@:FinalDone
@echo Done ... press any key to continue
@pause
