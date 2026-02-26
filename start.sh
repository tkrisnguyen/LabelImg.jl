#!/bin/bash
echo "========================================"
echo "LabelImg - Image Annotation Tool"
echo "========================================"
echo "Starting server..."
echo ""
echo "Once started, open your browser to:"
echo "http://localhost:8080"
echo ""
echo "Press Ctrl+C to stop the server"
echo "========================================"
echo ""

julia --project=. -e 'include("src/LabelImg.jl"); using .LabelImg; LabelImg.start(8080)'
