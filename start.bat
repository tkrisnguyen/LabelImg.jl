@echo off
echo ========================================
echo LabelImgJL - Image Annotation Tool
echo ========================================
echo Starting server...
echo.
echo Once started, open your browser to:
echo http://localhost:8080
echo.
echo Press Ctrl+C to stop the server
echo ========================================
echo.

julia --project=. -e "include(\"src/LabelImgJL.jl\"); using .LabelImgJL; LabelImgJL.start(8080)"

pause
