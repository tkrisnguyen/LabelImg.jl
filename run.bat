@echo off
REM Simple launcher for LabelImg without compilation
echo Starting LabelImg...
echo.

REM Check if Julia is available
where julia >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Julia not found in PATH
    echo Please install Julia from https://julialang.org/downloads/
    pause
    exit /b 1
)

REM Set port (default 8000, or use first argument)
set PORT=8000
if not "%1"=="" set PORT=%1

echo Starting server on port %PORT%...
echo Open your browser to: http://localhost:%PORT%
echo Press Ctrl+C to stop the server
echo.

REM Run the application
julia --project=. -e "ENV[\"PORT\"] = \"%PORT%\"; include(\"main.jl\")"

pause
