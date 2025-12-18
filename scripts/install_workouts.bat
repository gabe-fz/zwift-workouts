@echo off
REM Copy all workouts to each Zwift user custom workouts directory on Windows.
REM Zwift stores user-specific workouts under:
REM   %USERPROFILE%\Documents\Zwift\Workouts\<zwift_user_id>\
REM This script will replicate the workouts into every user id folder.

setlocal enabledelayedexpansion

set "SOURCE_DIR=%~dp0..\workouts"
set "ZWIFT_WORKOUTS_ROOT=%USERPROFILE%\Documents\Zwift\Workouts"

if not exist "%ZWIFT_WORKOUTS_ROOT%" (
  echo Zwift workouts root not found: %ZWIFT_WORKOUTS_ROOT% >&2
  exit /b 1
)

set "USER_COUNT=0"
for /d %%d in ("%ZWIFT_WORKOUTS_ROOT%\*") do (
  set /a USER_COUNT+=1
)

if %USER_COUNT%==0 (
  echo No user workout directories found under %ZWIFT_WORKOUTS_ROOT% >&2
  exit /b 1
)

echo Installing workouts from %SOURCE_DIR% into:
for /d %%d in ("%ZWIFT_WORKOUTS_ROOT%\*") do (
  echo   %%d
  
  REM Remove all existing .zwo files
  if exist "%%d\*.zwo" del /q "%%d\*.zwo"
  
  REM Copy new workouts
  copy "%SOURCE_DIR%\*.zwo" "%%d\" >nul
)

echo Done. Restart Zwift if it's running to see new workouts.
