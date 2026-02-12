#!/usr/bin/env julia

# Example usage of LabelImgJL

using Pkg
Pkg.activate(".")

include("src/LabelImgJL.jl")
using .LabelImgJL

# Start the annotation server
# Navigate to http://localhost:8080 in your browser
LabelImgJL.start(8080)

# To use:
# 1. Click "New Project" button
# 2. Enter project name (e.g., "My Dataset")
# 3. Enter image directory path (e.g., "/path/to/your/images")
# 4. Enter labels comma-separated (e.g., "cat, dog, person, car")
# 5. Click "Create"
# 6. Select a label from the sidebar
# 7. Choose a tool (Rectangle, Polygon, or Point)
# 8. Draw annotations on the image
# 9. Click "Save" to save annotations
# 10. Use "Previous" and "Next" to navigate between images
