@echo off
rem :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem ::             WLA DX compiling batch file v3              ::
rem :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: Do not edit anything unless you know what you're doing! ::
rem :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set WLAPATH=%~dp0

rem Cleanup to avoid confusion
if exist object.o del object.o

rem Compile "%WLAPATH%wla-65816.exe" -io Show.asm object.o

"%WLAPATH%wla-65816.exe" -i -v -o object.o Show.asm

rem Make linkfile
echo [objects]>linkfile
echo object.o>>linkfile

rem Link "%WLAPATH%wlalink.exe" -idrvs linkfile ROM.smc

"%WLAPATH%wlalink.exe" -i -d -r -v -S linkfile ROM.smc


rem Fixup
if exist ROM.smc.sym del ROM.smc.sym
ren ROM.sym ROM.smc.sym

rem Cleanup
if exist linkfile del linkfile
if exist object.o del object.o
PAUSE