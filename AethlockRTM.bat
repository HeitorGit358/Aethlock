@echo off
title Aethlock
mode 80,25

:: Check for Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ==========================================
    echo             AETHLOCK
    echo ==========================================
    echo.
    echo Please run Aethlock as Administrator.
    pause
    exit
)

:MENU
cls
echo ==========================================
echo                 AETHLOCK
echo ==========================================
echo.
echo  1) Install MS-DOS Mode/BCPE
echo  2) Switch sethc.exe by cmd.exe
echo  3) Install 7-Zip
echo  4) Activate Windows 7 Login screen [IN DEVELOPEMENT]
echo  5) Run as TrustedInstaller [IN DEVELOPEMENT]
echo  6) Add or remove "Take ownership" in Context Menu
echo  7) Sign-up Screen Manager [IN DEVELOPEMENT]
echo  8) Add "New BAT File" in Context Menu
echo  9) Uninstall Microsoft Edge
echo  10) Boot to MS-DOS Mode/BCPE
echo  11) Enable Windows "God Mode"
echo  12) Aethlock Version
echo.
echo  0) Exit
echo.

set /p choice=Select an option:

if "%choice%"=="1" goto MSDOS
if "%choice%"=="2" goto SETHCTOCMD
if "%choice%"=="3" goto INSTALL7ZIP
if "%choice%"=="4" goto WIN7LOGIN
if "%choice%"=="5" goto TRUSTED
if "%choice%"=="6" goto OWNERSHIP
if "%choice%"=="7" goto SIGNUPMENU
if "%choice%"=="8" goto ADDBAT
if "%choice%"=="9" goto EDGEUNINSTALL
if "%choice%"=="10" goto BOOTMSDOS
if "%choice%"=="11" goto GODMODE
if "%choice%"=="12" goto VERSION
if "%choice%"=="0" exit

goto MENU
:INSTALL7ZIP
cls
echo ==========================================
echo           INSTALL 7-ZIP
echo ==========================================
echo.

if exist "%ProgramFiles%\7-Zip\7z.exe" (
    echo 7-Zip is already installed!
    echo.
    pause
    goto MENU
)

echo Detecting system architecture...

if /I "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set "URL=https://github.com/ip7z/7zip/releases/download/26.02/7z2602-x64.exe"
) else (
    set "URL=https://github.com/ip7z/7zip/releases/download/26.02/7z2602.exe"
)

set "SETUP=%TEMP%\7zInstaller.exe"

echo.
echo Downloading installer...
curl -L "%URL%" -o "%SETUP%"

if errorlevel 1 (
    echo.
    echo Failed to download 7-Zip.
    pause
    goto MENU
)

echo.
echo Launching installer...
start "" "%SETUP%"

echo.
echo Installer launched successfully.
pause
goto MENU
:WIN7LOGIN
cls
echo ==========================================
echo        WINDOWS 7 LOGIN SCREEN
echo ==========================================
echo.
echo This feature is currently under development.
echo.
echo It will be available in a future version of Aethlock.
echo.
pause
goto MENU
:WIN7LOGINDEV
cls
echo ==========================================
echo       WINDOWS 7 LOGIN SCREEN
echo ==========================================
echo.

set /p confirm=Install Windows 7 Login Screen? (Y/N):

if /I "%confirm%"=="N" goto MENU
if /I not "%confirm%"=="Y" goto WIN7LOGIN

echo.
echo Disabling sign-up screen...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f

echo.
echo Downloading Windows 7 LogonUI files...

set "WIN7TEMP=%TEMP%\Aethlock_Win7Logon"

if exist "%WIN7TEMP%" rd /s /q "%WIN7TEMP%"
mkdir "%WIN7TEMP%"

curl -L "https://github.com/HeitorGit358/files-for-aethpill/releases/download/files1/ConsoleLogonHook.dll" -o "%WIN7TEMP%\ConsoleLogonHook.dll"

curl -L "https://github.com/HeitorGit358/files-for-aethpill/releases/download/files1/ConsoleLogonUI.dll" -o "%WIN7TEMP%\ConsoleLogonUI.dll"

curl -L "https://github.com/HeitorGit358/files-for-aethpill/releases/download/files1/installhooks.reg" -o "%WIN7TEMP%\installhooks.reg"


echo.
echo Backing up Windows.UI.Logon.dll...

if exist "%SystemRoot%\System32\Windows.UI.Logon.dll" (
    if not exist "%SystemRoot%\System32\Windows.UI.Logon.dll.backup" (
        ren "%SystemRoot%\System32\Windows.UI.Logon.dll" "Windows.UI.Logon.dll.backup"
    )
)


echo.
echo Copying files...

copy /Y "%WIN7TEMP%\ConsoleLogonHook.dll" "%SystemRoot%\System32\"
copy /Y "%WIN7TEMP%\ConsoleLogonUI.dll" "%SystemRoot%\System32\"


echo.
echo Installing hooks...

reg import "%WIN7TEMP%\installhooks.reg"


echo.
echo ==========================================
echo Windows 7 Login Screen installed!
echo Restart Windows to apply changes.
echo ==========================================

pause
goto MENU
:TRUSTED
cls
echo ==========================================
echo        RUN AS TRUSTEDINSTALLER
echo ==========================================
echo.
echo This feature is currently under development.
echo.
echo It will be available in a future version of Aethlock.
echo.
pause
goto MENU
:OWNERSHIP
cls
echo ==========================================
echo        TAKE OWNERSHIP CONTEXT MENU
echo ==========================================
echo.
echo 1) Add Take Ownership
echo 2) Remove Take Ownership
echo 0) Back
echo.

set /p ownchoice=Select an option:

if "%ownchoice%"=="1" goto ADDOWNERSHIP
if "%ownchoice%"=="2" goto REMOVEOWNERSHIP
if "%ownchoice%"=="0" goto MENU

goto OWNERSHIP


:ADDOWNERSHIP
cls
echo Adding Take Ownership...

reg add "HKCR\*\shell\TakeOwnership" /ve /d "Take Ownership" /f
reg add "HKCR\*\shell\TakeOwnership" /v "NoWorkingDirectory" /f
reg add "HKCR\*\shell\TakeOwnership\command" /ve /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f

reg add "HKCR\Directory\shell\TakeOwnership" /ve /d "Take Ownership" /f
reg add "HKCR\Directory\shell\TakeOwnership\command" /ve /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f

echo.
echo Take Ownership added!
pause
goto MENU


:REMOVEOWNERSHIP
cls
echo Removing Take Ownership...

reg delete "HKCR\*\shell\TakeOwnership" /f
reg delete "HKCR\Directory\shell\TakeOwnership" /f

echo.
echo Take Ownership removed!
pause
goto MENU
:SIGNUPMENU
:SIGNUPDEV
cls
echo ==========================================
echo        SIGN-UP SCREEN MANAGER
echo ==========================================
echo.
echo This feature is currently under development.
echo.
pause
goto MENU
:SIGNUPMENUDEV
cls
echo ==========================================
echo        SIGN-UP SCREEN MANAGER
echo ==========================================
echo.
echo 1) Disable sign-up screen
echo 2) Enable sign-up screen
echo 0) Back
echo.

set /p signupchoice=Select an option:

if "%signupchoice%"=="1" goto NOSIGNUP
if "%signupchoice%"=="2" goto ENABLESIGNUP
if "%signupchoice%"=="0" goto MENU

goto SIGNUPMENU


:NOSIGNUP
cls
echo ==========================================
echo        DISABLE SIGN-UP SCREEN
echo ==========================================
echo.

echo Disabling sign-up screen...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f

echo.
echo Disabled!
pause
goto MENU


:ENABLESIGNUP
cls
echo ==========================================
echo        ENABLE SIGN-UP SCREEN
echo ==========================================
echo.

echo Restoring sign-up screen...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 1 /f

echo.
echo Enabled!
pause
goto MENU
:ADDBAT
cls
echo ==========================================
echo        ADD NEW BAT FILE
echo ==========================================
echo.

echo Adding BAT file to New context menu...

reg add "HKCR\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f

if %errorlevel%==0 (
    echo.
    echo New BAT File added successfully!
) else (
    echo.
    echo Failed to add BAT File.
    echo Try running Aethlock as Administrator.
)

echo.
pause
goto MENU
:ABOUT
cls
echo ==========================================
echo                AETHLOCK
echo ==========================================
echo.
echo Aethlock System Utility
echo Version: 1.0
echo.
echo Created for %username%
echo.
echo Features:
echo - Windows customization
echo - System tools
echo - Context menu tweaks
echo - Installer modules
echo.
pause
goto MENU


:SYSTEMINFO
cls
echo ==========================================
echo             SYSTEM INFORMATION
echo ==========================================
echo.

echo Computer:
echo %COMPUTERNAME%

echo.
echo User:
echo %USERNAME%

echo.
echo Windows Version:
ver

echo.
echo Architecture:
echo %PROCESSOR_ARCHITECTURE%

echo.
pause
goto MENU
:ENABLESIGNUP
cls
echo ==========================================
echo        ENABLE SIGN-UP SCREEN
echo ==========================================
echo.

echo Restoring Windows sign-up screen...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 1 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 1 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 1 /f

echo.
echo Sign-up screen enabled!
echo Restart Windows Explorer or reboot to apply.
pause
goto MENU
:EDGEUNINSTALL
cls
echo ==========================================
echo       UNINSTALL MICROSOFT EDGE
echo ==========================================
echo.

echo This will remove Microsoft Edge Chromium.
echo.
set /p CONFIRM=Continue? (Y/N):

if /I "%CONFIRM%"=="N" goto MENU
if /I not "%CONFIRM%"=="Y" goto EDGEUNINSTALL

echo.
echo Closing Edge processes...

taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im msedgewebview2.exe >nul 2>&1
taskkill /f /im MicrosoftEdgeUpdate.exe >nul 2>&1


echo.
echo Searching Edge installation...

set "EDGE_BASE=%PROGRAMFILES(X86)%\Microsoft\Edge\Application"

if not exist "%EDGE_BASE%" (
    echo Edge installation not found.
    goto EDGE_CLEANUP
)

set "EDGE_VERSION_DIR="

for /f "delims=" %%D in ('dir /b /ad "%EDGE_BASE%" ^| findstr /r "^[0-9]"') do (
    set "EDGE_VERSION_DIR=%%D"
)

if "%EDGE_VERSION_DIR%"=="" (
    echo Edge version folder not found.
    goto EDGE_CLEANUP
)

set "SETUP_EXE=%EDGE_BASE%\%EDGE_VERSION_DIR%\Installer\setup.exe"

if exist "%SETUP_EXE%" (
    echo Running Edge uninstaller...
    "%SETUP_EXE%" --uninstall --system-level --verbose-logging --force-uninstall
) else (
    echo Edge setup.exe not found.
)


echo.
echo Removing user installation...

set "EDGE_USER_BASE=%LOCALAPPDATA%\Microsoft\Edge\Application"

if exist "%EDGE_USER_BASE%" (
    for /f "delims=" %%D in ('dir /b /ad "%EDGE_USER_BASE%" ^| findstr /r "^[0-9]"') do (
        if exist "%EDGE_USER_BASE%\%%D\Installer\setup.exe" (
            "%EDGE_USER_BASE%\%%D\Installer\setup.exe" --uninstall --verbose-logging --force-uninstall
        )
    )
)


:EDGE_CLEANUP
echo.
echo Cleaning shortcuts...

del /f /q "%PUBLIC%\Desktop\Microsoft Edge.lnk" >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\Microsoft Edge.lnk" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" >nul 2>&1


echo.
echo Removing remaining folders...

rmdir /s /q "%PROGRAMFILES(X86)%\Microsoft\Edge" >nul 2>&1
rmdir /s /q "%PROGRAMFILES(X86)%\Microsoft\EdgeUpdate" >nul 2>&1
rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge" >nul 2>&1
rmdir /s /q "%LOCALAPPDATA%\Microsoft\EdgeCore" >nul 2>&1
rmdir /s /q "%LOCALAPPDATA%\Microsoft\EdgeUpdate" >nul 2>&1


echo.
echo ==========================================
echo Microsoft Edge removal completed.
echo ==========================================
echo.

pause
goto MENU
:MSDOS
cls
echo ==========================================
echo     MS-DOS MODE/BCPE INSTALLER
echo ==========================================
echo.

set "TMP=%TEMP%\Aethlock_BCPE"
if exist "%TMP%" rd /s /q "%TMP%"
mkdir "%TMP%"

echo Downloading files...

curl -L "https://github.com/AaravRepos/MS-DOS-Mode-for-newer-versions/releases/download/1.0.1/msdos.bat" -o "%TMP%\msdos.bat"
curl -L "https://github.com/AaravRepos/MS-DOS-Mode-for-newer-versions/releases/download/1.0.1/reboot.bat" -o "%TMP%\reboot.bat"
curl -L "https://github.com/AaravRepos/MS-DOS-Mode-for-newer-versions/releases/download/1.0.1/win.bat" -o "%TMP%\win.bat"

echo.
echo Installing...

copy /Y "%TMP%\msdos.bat" "%SystemRoot%\System32\" >nul
copy /Y "%TMP%\reboot.bat" "%SystemRoot%\System32\" >nul
copy /Y "%TMP%\win.bat" "%SystemRoot%\System32\" >nul

echo.
echo Installation completed.
echo.
echo Commands installed:
echo   msdos
echo   reboot
echo   win
echo.
pause
goto MENU
:BOOTMSDOS
cls
echo ==========================================
echo          BOOT TO MS-DOS MODE
echo ==========================================
echo.

if not exist "%SystemRoot%\System32\msdos.bat" (
    echo BCPE / MS-DOS Mode is not installed.
    echo Install it first using option 1.
    echo.
    pause
    goto MENU
)

echo Starting MS-DOS Mode...
call "%SystemRoot%\System32\msdos.bat"

pause
goto MENU
:SETHCTOCMD
cls
REM https://github.com/Sid12323/sethcexploit/ made by sciencesid
cd C:\Windows\System32\
echo Taking Ownership of SETHC...
takeown /f sethc.exe
echo Overriding Ownership of Sethc.exe is complete!
echo Edit permissions...
icacls sethc.exe /grant %username%:F /t /q
echo Done!
echo In order to replace sethc with cmd,
pause
echo Ok! Replacing!
copy cmd.exe sethc.exe
echo Done!
pause
goto MENU
:VERSION
cls
echo ==========================================
echo              AETHLOCK VERSION
echo ==========================================
echo.
echo Aethlock by AethDoesOSes
echo Build 2608.05
echo.
pause
goto MENU

:GODMODE
cls
echo ==========================================
echo                GOD MODE
echo ==========================================
echo.

set "GODTEMP=%TEMP%\GodMode.exe"
set "GODINSTALL=%SystemRoot%\GodMode.exe"

echo Downloading GodMode.exe...
echo.

curl.exe -L -A "Mozilla/5.0" "https://github.com/HeitorGit358/files-for-aethpill/releases/download/files1/GodMode.exe" -o "%GODTEMP%"

if not exist "%GODTEMP%" (
    echo Download failed!
    pause
    goto MENU
)

for %%A in ("%GODTEMP%") do set SIZE=%%~zA

echo Download size: %SIZE% bytes
echo.

if %SIZE% LSS 50000 (
    echo ERROR: Downloaded file is too small.
    echo Check your internet connection or GitHub release.
    del "%GODTEMP%"
    pause
    goto MENU
)

echo Installing GodMode.exe...

copy /Y "%GODTEMP%" "%GODINSTALL%" >nul

if not exist "%GODINSTALL%" (
    echo Installation failed!
    pause
    goto MENU
)

echo.
echo Creating God Mode folder...

set "GODFOLDER=%SYSTEMROOT%\System32\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"

if not exist "%GODFOLDER%" (
    mkdir "%GODFOLDER%"
)

echo.
echo God Mode installed successfully!
echo.

start "" "%GODINSTALL%"

pause
goto MENU