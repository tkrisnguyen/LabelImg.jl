# Building LabelImgJL Standalone Executable

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
- **Windows:** `LabelImgJL-dist\bin\LabelImgJL.exe`
- **Linux/Mac:** `LabelImgJL-dist/bin/LabelImgJL`

### Step 3: Test the Executable

```bash
# Windows
.\LabelImgJL-dist\bin\LabelImgJL.exe

# Linux/Mac
./LabelImgJL-dist/bin/LabelImgJL

# Custom port
.\LabelImgJL-dist\bin\LabelImgJL.exe 3000
```

Open browser to `http://localhost:8080` (or your custom port)

## Distributing to Students

### Option A: Zip the Entire Folder
1. Zip the entire `LabelImgJL-dist` folder
2. Students unzip and run the executable from `bin/` folder
3. **Size:** ~500MB-1GB (includes Julia runtime and all libraries)

### Option B: Create an Installer (Advanced)
Use NSIS (Windows) or create a .deb/.rpm (Linux) package

## Student Instructions

Create a simple README for students:

```
# LabelImgJL - Image Annotation Tool

## How to Run

1. Extract the zip file
2. Double-click `bin/LabelImgJL.exe` (Windows) or run `./bin/LabelImgJL` (Linux/Mac)
3. Open browser to http://localhost:8080
4. Click "New Project" to start annotating images

## Usage

1. **Create Project:** Enter project name, select image folder, add labels (comma-separated)
2. **Select Label:** Click on a label in the sidebar
3. **Choose Tool:** Rectangle, Polygon, or Point
4. **Draw Annotations:**
   - Rectangle: Click and drag
   - Polygon: Left-click to add points, right-click to finish
   - Point: Single click
5. **Save:** Click "Save" button to export annotations to JSON

## Troubleshooting

- Port already in use? Run with custom port: `LabelImgJL.exe 3000`
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

### "Out of Memory" during build
- Close other applications
- Increase system swap/page file
- Use a machine with at least 8GB RAM

### "Cannot find package" errors
- Ensure all dependencies are installed: `julia --project=. -e 'using Pkg; Pkg.instantiate()'`
- Try: `julia --project=. -e 'using Pkg; Pkg.resolve(); Pkg.instantiate()'`

### Build fails on Genie
- Genie might have path dependencies. If issues persist, consider containerization (Docker) instead.
