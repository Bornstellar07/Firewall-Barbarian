@echo off
setlocal enabledelayedexpansion

::admin check
openfiles >nul 2>nul
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -ArgumentList '%*' -Verb runAs"
    exit /b
)

::parameters
set "action=%~1"
set "directory=%~2"
set "direction=%~3"

::action check
if "%action%"=="" (
    echo Please provide an action : "block" or "unblock".
    exit /b
)

::use active directory if none specified
if "%directory%"=="" (
    set "directory=%cd%"
)

::"--in" and "--out" can be used without specifying a directory
if /i "%directory%"=="--in" (
    set "direction=%directory%"
    set "directory=%cd%"
) else if /i "%directory%"=="--out" (
    set "direction=%directory%"
    set "directory=%cd%"
)

::Absolute path
for %%A in ("%directory%") do set "directory=%%~fA"

::directory existence check
if not exist "%directory%" (
    echo Directory not found: %directory%.
    exit /b
)

::direction check
if not "%direction%"=="" if /i not "%direction%"=="--in" if /i not "%direction%"=="--out" (
    echo Invalid direction. Use : "--in" or "--out".
    exit /b
)

::Search for programs
for /r "%directory%" %%f in (*.exe) do (
    set "program_path=%%f"
    echo Found program: !program_path!
    call :ProcessProgram "!program_path!"
)

goto :eof

:ProcessProgram
set "program_path=%~1"
echo Processing program: %program_path%

if /i "%action%"=="block" (
    echo Blocking program : %program_path%...

    if "%direction%"=="" (
        netsh advfirewall firewall add rule name="In_%program_path%" dir=in program="%program_path%" action=block
        netsh advfirewall firewall add rule name="Out_%program_path%" dir=out program="%program_path%" action=block
    ) else if /i "%direction%"=="--in" (
        netsh advfirewall firewall add rule name="In_%program_path%" dir=in program="%program_path%" action=block
    ) else if /i "%direction%"=="--out" (
        netsh advfirewall firewall add rule name="Out_%program_path%" dir=out program="%program_path%" action=block
    )
    echo Blocking done for %program_path%.
    echo.
) else if /i "%action%"=="unblock" (
    echo Unblocking program : %program_path%...

    if "%direction%"=="" (
        netsh advfirewall firewall delete rule name="In_%program_path%"
        netsh advfirewall firewall delete rule name="Out_%program_path%"
    ) else if /i "%direction%"=="--in" (
        netsh advfirewall firewall delete rule name="In_%program_path%"
    ) else if /i "%direction%"=="--out" (
        netsh advfirewall firewall delete rule name="Out_%program_path%"
    )
    echo Unblocking done for %program_path%.
    echo.
) else (
    echo Invalid action : use "block" or "unblock".
)

goto :eof
pause