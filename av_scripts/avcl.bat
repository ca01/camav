echo off
REM This is the script for scanning a particular file passed as argument. The format of the command is avmc.bat c:\filename.exe
echo on 

cd "C:\Program Files\ClamWin\bin\"

set outputfilename=%~dp1avcl.txt
echo off
rem this command is actualy made from  set outputfilename=  %~dp1 avmc.txt. This parameter is the path of the file argument passed to the script %~dp1
echo on

clamscan.exe --database="C:\Documents and Settings\All Users\.clamwin\db" --log=%outputfilename% %~1 

cd "c:\script\"

shutdown -s -f -t 3