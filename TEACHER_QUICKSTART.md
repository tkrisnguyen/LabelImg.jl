# Quick Start Guide for Teachers/Distributors

## Building the Executable

### One-time Setup (5 minutes)
```bash
# Navigate to project folder
cd LabelImg

# Install dependencies
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

### Build Executable (10-20 minutes first time)
```bash
julia --project=. build.jl
```

**Wait for it to complete.** You'll see:
```
Build complete!
Executable location: LabelImg-dist/bin/LabelImg
```

## Distributing to Students

### What to Give Students

**Option 1: Simple Zip (Recommended)**
1. Compress the `LabelImg-dist` folder to ZIP
2. Also include `STUDENT_GUIDE.md` in the ZIP
3. Share the ZIP file (~500MB-1GB)

**Option 2: Create Better Package**
1. Copy `STUDENT_GUIDE.md` into `LabelImg-dist/` folder
2. Copy `launcher-template.bat` to `LabelImg-dist/bin/` and rename to `Start-LabelImg.bat`
3. Compress the entire `LabelImg-dist` folder
4. Share the ZIP file

### Testing Before Distribution

```bash
# Windows
cd LabelImg-dist\bin
.\LabelImg.exe

# Linux/Mac
cd LabelImg-dist/bin
./LabelImg
```

Open browser to `http://localhost:8080` and verify it works.

## Student Instructions (Simple Version)

Tell your students:

```
1. Extract the ZIP file
2. Go to the 'bin' folder
3. Double-click LabelImg.exe (Windows) or run ./LabelImg (Mac/Linux)
4. Open browser to: http://localhost:8080
5. Read STUDENT_GUIDE.md for detailed instructions
```

## Platform Notes

⚠️ **Important**: The executable only works on the platform it was built on:
- Built on Windows → Works only on Windows
- Built on Linux → Works only on Linux  
- Built on Mac → Works only on Mac

**For multi-platform support:**
- Build separately on each platform, OR
- Provide Julia installation instructions as fallback

## Common Issues

### Build fails
- Ensure you have at least 8GB RAM
- Close other applications during build
- Try: `julia --project=. -e 'using Pkg; Pkg.resolve(); Pkg.instantiate()'`

### Executable too large
- Normal! It includes entire Julia runtime (~500MB-1GB)
- This is the trade-off for "no Julia installation needed"

### Students report "port already in use"
- Tell them to run: `LabelImg.exe 3000` (or any other port)
- Then open: `http://localhost:3000`

## Alternative: Keep it Simple

If the executable is too large or build fails, just tell students to:

1. Install Julia from https://julialang.org/downloads/
2. Download your LabelImg folder
3. Run:
```julia
cd("path/to/LabelImg")
using Pkg
Pkg.activate(".")
Pkg.instantiate()
include("src/LabelImg.jl")
LabelImg.start(8080)
```

## Quick Checklist

- [ ] Build completed successfully
- [ ] Tested the executable locally
- [ ] Included STUDENT_GUIDE.md in distribution
- [ ] Created ZIP file of appropriate size
- [ ] Uploaded to file sharing service (Google Drive, Dropbox, etc.)
- [ ] Sent download link to students
- [ ] Announced deadline for annotation task
- [ ] Specified where students should submit their annotation JSON files

## Collecting Student Work

Students will generate files named:
```
annotations_<project_name>.json
```

Located in the same folder as their images.

**Submission instructions for students:**
"Submit your `annotations_*.json` file via [your submission method]"
