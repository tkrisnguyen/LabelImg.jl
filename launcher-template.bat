@echo off
REM Simple launcher for LabelImgJL
echo ============================================================
echo LabelImgJL - Image Annotation Tool
echo ============================================================
echo Starting server...
echo.
echo Once started, open your browser to: http://localhost:8080
echo.
echo Press Ctrl+C to stop the server
echo ============================================================
echo.

"%~dp0LabelImgJL.exe" %*

pause
