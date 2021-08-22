
Even if this script was created to ecompile the Sims 4 .pyc for modding it works with any kind of .pyc file, just don't try python 3.9+ because the flow is different and all this tools are for python up to 3.8 except for unpyc3 wich is for 3.7.

this script is based on darkkitten30's script (https://modthesims.info/t/532644) i'm aiming to decompile as many .pyc 
files as possible by using the best tools available right now.

```
Requirenments:

decompyle3 (https://github.com/rocky/python-decompile3)
uncompyle6 (https://pypi.org/project/uncompyle6/)
unpyc3 (https://github.com/andrew-tavera/unpyc37/blob/master/unpyc3.py)
```
uncompyle6 and unpyc3 will be downloaded automatically, so no need for manual install.

Edit the script and fill as needed with NO quotation marks:  

```
set SIMS4DIR=GAME_DIR
set TEMPDIR=TEMP_DIR_FOR_PROCESSING
set ZIPPROGRAM=C:\Program Files\7-Zip\7z.exe
set UNPYC=PAH_TO_unpyc3.py
```

Launch from cmd, powershell, anaconda powershell or doubleclick


this script has a really high success rate, it only fails to decompile 2 files: \base\lib\turtle.py and base\lib\_pydecimal.py, 
i've tried pycdc, uncompyle, decompyle, easy python decompiler, and unpyc3, since uncompyle is a rewrite of decompyle it's used
as main because of it's reliability, followed by decompyle and finally unpyc3. I ditched pycd because it generates windowed
alerts and has a success rate lower than unpyc3 and easypythondecompiler because it's outdated and not maintained anymore.



