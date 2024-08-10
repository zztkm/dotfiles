@echo off

setlocal
for /f "usebackq delims=" %%A in (`cd`) do set PWD=%%A
echo %PWD%

set DIST=%PWD%\nvim-config
set SRC=%LOCALAPPDATA%\nvim
echo %SRC%
echo %DIST%
mklink /D %SRC% %DIST%

set NYAGOS_CONFIG_DIST=%PWD%\windows\nyagos.lua
set NYAGOS_CONFIG_SRC=%USERPROFILE%\.nyagos
mklink %NYAGOS_CONFIG_SRC% %NYAGOS_CONFIG_DIST%
