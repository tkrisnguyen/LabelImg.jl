# Building LabelImg Standalone Executable

This guide explains how to create a standalone executable that your students can run without installing Julia.

## Prerequisites

- Julia 1.9 or higher installed on *your* machine (the build machine)
- All dependencies installed: `julia --project=. -e 'using Pkg; Pkg.instantiate()'`

## Building the Executable

### Step 1: Run the Build Script

```bash
julia --project=. build.jl
```

This will:
- Install PackageCompiler (if needed)
- Compile all dependencies
- Create a standalone executable with all Julia runtime included
- **Takes 10-20 minutes on first build** (subsequent builds are faster)

### Step 2: Find the Executable

After building, the executable will be in:
- **Windows:** `LabelImg-dist\bin\LabelImg.exe`
- **Linux/Mac:** `LabelImg-dist/bin/LabelImg`

### Step 3: Test the Executable

```bash
# Windows
.\LabelImg-dist\bin\LabelImg.exe

# Linux/Mac
./LabelImg-dist/bin/LabelImg

# Custom port
.\LabelImg-dist\bin\LabelImg.exe 3000
```

Open browser to `http://localhost:8080` (or your custom port)

## Distributing to Students

### Option A: Zip the Entire Folder
1. Zip the entire `LabelImg-dist` folder
2. Students unzip and run the executable from `bin/` folder
3. **Size:** ~500MB-1GB (includes Julia runtime and all libraries)

### Option B: Create an Installer (Advanced)
Use NSIS (Windows) or create a .deb/.rpm (Linux) package

## Student Instructions

Create a simple README for students:

```
# LabelImg - Image Annotation Tool

## How to Run

1. Extract the zip file
2. Double-click `bin/LabelImg.exe` (Windows) or run `./bin/LabelImg` (Linux/Mac)
3. Open browser to http://localhost:8080
4. Click "New Project" to start annotating images

## Usage

1. **Create Project:** Enter project name, select image folder, add labels (comma-separated)
2. **Select Label:** Click on a label in the sidebar
3. **Choose Tool:** Rectangle, Rotated Box, Polygon, or Point
4. **Draw Annotations:**
   - Rectangle: Click and drag
   - Rotated Box: Click 3 points (A, B define first edge; C completes box)
   - Polygon: Left-click to add points, right-click to finish
   - Point: Single click
5. **Save:** Click "Save" button to export annotations to JSON

## Troubleshooting

- Port already in use? Run with custom port: `LabelImg.exe 3000`
- Can't see images? Make sure image folder path is correct
- Need help? Contact [your email]
```

## Build Size Optimization

The executable is large because it includes:
- Julia runtime (~300MB)
- All package dependencies
- Precompiled system images

To reduce size:
- Remove unused dependencies from Project.toml
- Use `filter_stdlibs=true` in build.jl (may break some features)

## Platform-Specific Builds

You must build on the target platform:
- Windows executable must be built on Windows
- Linux executable must be built on Linux
- macOS executable must be built on macOS

For cross-platform support, build on each platform separately or use CI/CD with GitHub Actions.

## Troubleshooting Build Issues

### Windows: "Path too long" or ENOENT errors
This happens when file paths exceed Windows' 260-character limit.

**Solution 1: Build to shorter path (Easiest)**
```julia
# In build.jl, change output_dir to:
output_dir = "C:\\LabelImg-dist"
```

**Solution 2: Enable Long Path Support**
Run PowerShell as Administrator:
```powershell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
```
Then restart your computer.

**Solution 3: Move project to shorter path**
Move the entire LabelImg folder to `C:\LabelImg` and build from there.

### "Out of Memory" during build
- Close other applications
- Increase system swap/page file
- Use a machine with at least 8GB RAM

### "Cannot find package" errors
- Ensure all dependencies are installed: `julia --project=. -e 'using Pkg; Pkg.instantiate()'`
- Try: `julia --project=. -e 'using Pkg; Pkg.resolve(); Pkg.instantiate()'`

### Build fails on Genie
- Genie might have path dependencies. If issues persist, consider containerization (Docker) instead.

### Precompilation errors (Revise, Genie, etc.)
PackageCompiler struggles with some packages. If you get precompilation errors:

**Alternative: Skip executable build and use Julia directly**
Instead of building an executable, give students a simpler launcher script:

**For Windows students** - Create `start.bat`:
```batch
@echo off
julia --project=. -e "include(\"src/LabelImg.jl\"); using .LabelImg; LabelImg.start(8080)"
pause
```

**For Linux/Mac students** - Create `start.sh`:
```bash
#!/bin/bash
julia --project=. -e 'include("src/LabelImg.jl"); using .LabelImg; LabelImg.start(8080)'
```

Then distribute:
1. The entire project folder (with Project.toml, Manifest.toml, src/)
2. The launcher script
3. Instructions to install Julia first

This approach:
- ✅ Smaller download (~50MB vs 500MB+)
- ✅ No build errors
- ✅ Works reliably
- ❌ Students need to install Julia (but it's quick)
