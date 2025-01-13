@echo off
setlocal

::admin check
openfiles >nul 2>nul
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -ArgumentList '%*' -Verb runAs"
)

set "action=%~1"
set "program_name=%~2"
set "direction=%~3"

if "%action%"=="" (
    echo Please provide an action : "block" or "unblock".
    exit /b
)

if "%program_name%"=="" (
    echo Please provide the name of the program.
    exit /b
)

if not "%direction%"=="" if /i not "%direction%"=="--in" if /i not "%direction%"=="--out" (
    echo Invalid direction. Use : "--in" or "--out".
    exit /b
)

:: Path builder
set "program_path=%cd%\%program_name%"

if not exist "%program_path%" (
    echo Program not found in current directory: %program_name%.
    exit /b
)

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
    echo Blocking operation complete.
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
    echo Unblocking operation complete.
) else (
    echo Invalid action : use "block" or "unblock".
)

pause