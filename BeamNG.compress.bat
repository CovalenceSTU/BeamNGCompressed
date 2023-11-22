rem BeamNG Content Compressor, by Covalence
:start
@echo off
color b0
chcp 65001
mode con: cols=80 lines=20
title BeamNG.compress
set topBorder=╔══════════════════════════════════════════════════════════════════════════════╗
set midBorder=╠══════════════════════════════════════════════════════════════════════════════╣
set  midBlank=║                                                                              ║
set lowBorder=╚══════════════════════════════════════════════════════════════════════════════╝
rem BeamNG Path Variable
rem Change this if you installed BeamNG.drive to a custom location.
set beamPath=C:\Program Files (x86)\Steam\steamapps\common\BeamNG.drive

:mainmenu
cls
echo %topBorder%
echo ║                    BeamNG Content Compressor - Main Menu                     ║
echo %midBorder%
echo %midBlank%
echo ║           Unpacks and compresses BeamNG.drive levels and vehicles,           ║
echo ║       saving appx. 25GB of space. (at least 3GB free space required)         ║
echo %midBlank%
echo %midBlank%
echo %midBlank%
echo ║            This program needs 7-zip to run! If you don't have it,            ║
echo ║               get it here: https://www.7-zip.org/download.html               ║
echo %midBlank%
echo %midBorder%
echo ║ (1) Compress content                                                         ║
echo ║ (2) Backup content (optional)                                                ║
echo ║ (3) Restore backup (if something went wrong)                                 ║
echo ║ (4) Delete backup (if it exists)                                             ║
echo ║ (0) Exit                                                                     ║
echo %lowBorder%
choice /c 12340 /n /m "Choice: "
if %errorlevel%==4 goto :delete
if %errorlevel%==3 goto :restore
if %errorlevel%==2 goto :backup
if %errorlevel%==1 goto :compress
exit 0

:compress
cls
echo %topBorder%
echo ║                 BeamNG Content Compressor - Compress Content                 ║
echo %lowBorder%
echo This will take a very long time, especially on slow CPUs.
echo Some files are very large - if the cursor is flashing, it is not frozen.
pause
echo Compressing levels...
cd "%beamPath%\content\levels"
for %%i in (*.zip) do (
  "C:\Program Files\7-Zip\7z.exe" x %%i -sccUTF-8
  del /q %%i
  "C:\Program Files\7-Zip\7z.exe" a %%i -mx9 -sccUTF-8 "%beamPath%\content\levels\levels"
  rmdir /s /q "%beamPath%\content\levels\levels"
)
echo Compressing vehicles...
cd "%beamPath%\content\vehicles"
for %%j in (*.zip) do (
  "C:\Program Files\7-Zip\7z.exe" x %%j -sccUTF-8
  del /q %%j
  "C:\Program Files\7-Zip\7z.exe" a %%j -mx9 -sccUTF-8 "%beamPath%\content\vehicles\vehicles"
  rmdir /s /q "%beamPath%\content\vehicles\vehicles"
)
echo Compressing art...
cd "%beamPath%\content"
"C:\Program Files\7-Zip\7z.exe" x art_shapes.zip -sccUTF-8
del /q art_shapes.zip
"C:\Program Files\7-Zip\7z.exe" a art_shapes.zip -mx9 -sccUTF-8 "%beamPath%\content\art"
rmdir /s /q "%beamPath%\content\art"
"C:\Program Files\7-Zip\7z.exe" x art_sound.zip -sccUTF-8
del /q art_sound.zip
"C:\Program Files\7-Zip\7z.exe" a art_sound.zip -mx9 -sccUTF-8 "%beamPath%\content\art"
rmdir /s /q "%beamPath%\content\art"
echo All files compressed!
pause
goto :mainmenu

:backup
cls
echo %topBorder%
echo ║                  BeamNG Content Compressor - Backup Content                  ║
echo %lowBorder%
echo This will copy BeamNG.drive content to your Documents folder.
echo At least 45GB of free space required.
pause
mkdir "%userprofile%\Documents\BeamNG.backup"
robocopy "%beamPath%\content" "%userprofile%\Documents\BeamNG.backup" /e /j /sec /xf "audio.zip"
copy "%localappdata%\BeamNG.drive\version.txt" "%userprofile%\Documents\BeamNG.backup\version.txt"
pause
goto :mainmenu

:restore
setlocal ENABLEDELAYEDEXPANSION
cls
echo %topBorder%
echo ║                 BeamNG Content Compressor - Restore Content                  ║
echo %lowBorder%
echo This will restore backed up BeamNG.drive content.
rem Batch script is a terrible language, as shown below
if exist "%userprofile%\Documents\BeamNG.backup\version.txt" (
  set /p backupVer=<"%userprofile%\Documents\BeamNG.backup\version.txt"
  set /p gameVer=<"%localappdata%\BeamNG.drive\version.txt"
)
if exist "%userprofile%\Documents\BeamNG.backup\version.txt" (
  if not "%backupVer%"=="%gameVer%" echo Game version %gameVer% is different then backup version %backupVer%.
  choice /m "Restore?"
  if !errorlevel!==2 (
    endlocal
	goto :mainmenu
  )
  robocopy "%userprofile%\Documents\BeamNG.backup" "%beamPath%\content" /e /j /im /sec /xf "version.txt"
  choice /m "Restore successful, delete backup?"
  if !errorlevel!==1 (
    rmdir /s "%userprofile%\Documents\BeamNG.backup"
  )
  endlocal
  goto :mainmenu
) else (
  endlocal
  echo Could not identify backup!
  pause
  goto :mainmenu
)

:delete
cls
echo %topBorder%
echo ║                  BeamNG Content Compressor - Delete Backup                   ║
echo %lowBorder%
if exist "%userprofile%\Documents\BeamNG.backup" (
  echo This will delete any backed up BeamNG.drive content.
  echo Make sure there are no issues or missing content in-game first!
  rmdir /s "%userprofile%\Documents\BeamNG.backup"
  goto :mainmenu
) else (
  echo No backup found!
  pause
  goto :mainmenu
)