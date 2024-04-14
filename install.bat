@echo off

setlocal
for /f "usebackq delims=" %%A in (`cd`) do set PWD=%%A
echo %PWD%

set DIST=%PWD%\nvim-windows
set SRC=%LOCALAPPDATA%\nvim
echo %SRC%
echo %DIST%
mklink /D %SRC% %DIST%
