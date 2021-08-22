```
this script is based on darkkitten30's script (https://modthesims.info/t/532644) i'm aiming to decompile as many .pyc files as possible by using the best tools available right now.


Requirenments:

decompyle3 (https://github.com/rocky/python-decompile3)
uncompyle6 (https://pypi.org/project/uncompyle6/)
unpyc3 (https://github.com/andrew-tavera/unpyc37/blob/master/unpyc3.py)


edit and fill as needed:  

set SIMS4DIR=GAME_DIR
set TEMPDIR=TEMP_DIR_FOR_PROCESSING
set ZIPPROGRAM=C:\Program Files\7-Zip\7z.exe
set set UNPYC=PAH_TO_unpyc3.py


launch from cmd, powershell or doubleclick

this script has a really high success rate, it only fails to decompile \base\lib\turtle.py and base\lib\_pydecimal.py, i've tried a lot of decompilers: pycdc, uncompyle, decompyle, easy python decompiler and unpyc3, since uncompyle is a rewrite of decompyle it's used as main because of it's reliability, followed by decompyle and finally unpyc3.
```


