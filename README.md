# LabelImg

🏷️ **LabelImg** is an image annotation tool built with Julia, inspired by Label Studio.

The Vietnamese version of this README is available at [README.vi.md](README.vi.md).

## ✨ Features

- 🖼️ **Modern web UI**: clean, easy-to-use interface
- 📦 **Multiple annotation types**: Rectangle, Rotated Rectangle, Polygon, Point
- 🎨 **Label management**: create and manage custom labels
- 💾 **JSON export**: save annotations in JSON format
- ⌨️ **Fast navigation**: move between images quickly
- 🎯 **Project-based workflow**: organize work by project

## 📋 Requirements

- Julia 1.9+
- Dependencies (managed via `Project.toml`):
  - Genie.jl
  - Images.jl
  - FileIO.jl
  - JSON3.jl

## 🚀 Installation

```julia
# Clone repository
git clone https://github.com/tkrisnguyen/LabelImg.jl.git
cd LabelImg.jl

# Activate project environment
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

## 💻 Usage

### Option 1: Run the example script

```julia
julia example.jl
```

### Option 2: Run from Julia REPL

```julia
using Pkg
Pkg.activate(".")

include("src/LabelImg.jl")
using .LabelImg

# Start server on port 8080
LabelImg.start(8080)
```

Then open your browser at `http://localhost:8080`.

### Option 3: Build a standalone executable (for users without Julia)

```julia
julia --project=. build.jl
```

After building (10-20 minutes on first build), the executable is in `LabelImg-dist/bin/`:
- **Windows**: `LabelImg.exe`
- **Linux/Mac**: `LabelImg`

See [BUILD.md](BUILD.md) for details.

## 📖 Quick User Guide

1. **Create a project**
   - Click `New Project`
   - Enter project name
   - Enter image directory path
   - Enter labels (comma-separated)
   - Click `Create`

2. **Annotate images**
   - Select a label from the left panel
   - Select a tool: Rectangle, Rotated Box, Polygon, or Point
   - Draw on the image
   - Click `Save`

3. **Navigate images**
   - Use `Previous` and `Next`
   - Annotations are saved per image

4. **Annotation tools**
   - **Rectangle**: click and drag
   - **Rotated Box**: click 3 points (A/B define first edge, C completes box)
   - **Polygon**: left-click to add points, right-click to finish (minimum 3 points)
   - **Point**: single click

## 📁 Output JSON Structure

Annotations are saved in JSON format:

```json
{
  "project": "My Dataset",
  "labels": ["cat", "dog", "person"],
  "annotations": [
    {
      "image": "/path/to/image.jpg",
      "annotations": [
        {
          "type": "rectangle",
          "label": "cat",
          "x": 100,
          "y": 150,
          "width": 200,
          "height": 180,
          "color": "#e74c3c"
        },
        {
          "type": "rotatedRect",
          "label": "dog",
          "points": [
            {"x": 150, "y": 100},
            {"x": 350, "y": 150},
            {"x": 320, "y": 280},
            {"x": 120, "y": 230}
          ],
          "color": "#3498db"
        }
      ],
      "metadata": {
        "timestamp": "2026-02-09T10:30:00"
      }
    }
  ]
}
```

## 🔧 API Endpoints

- `GET /` - main web interface
- `POST /api/project/create` - create project
- `GET /api/image/:index` - get image by index
- `GET /api/image/next` - next image
- `GET /api/image/prev` - previous image
- `POST /api/annotations/save` - save annotations

## 🤝 Contributing

Contributions, issues, and feature requests are welcome.

## 📝 License

MIT License

## 🙏 Credits

Inspired by [Label Studio](https://labelstud.io/) and [LabelImg](https://github.com/tzutalin/labelImg)