@echo off
REM Setup and run LabelImgJL - First-time setup script
echo ============================================================
echo LabelImgJL Setup and Launch
echo ============================================================
echo.

REM Check if Julia is available
where julia >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Julia not found in PATH
    echo Please install Julia from https://julialang.org/downloads/
    pause
    exit /b 1
)

echo Step 1: Installing dependencies...
julia --project=. -e "using Pkg; Pkg.instantiate(); Pkg.precompile()"

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo ============================================================
echo Setup complete!
echo ============================================================
echo.
echo Starting LabelImgJL server...
echo Open your browser to: http://localhost:8000
echo Press Ctrl+C to stop the server
echo.
echo Next time, you can use run.bat to start faster
echo ============================================================
echo.

REM Run the application
julia --project=. -e "include(\"main.jl\")"

pause
