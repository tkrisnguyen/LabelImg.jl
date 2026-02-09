# Setup script for LabelImgJL

using Pkg

println("🔧 Setting up LabelImgJL...")

# Activate the project environment
Pkg.activate(".")

println("📦 Installing dependencies...")

# Add required packages
packages = [
    "Genie",
    "Images",
    "FileIO",
    "JSON3"
]

for pkg in packages
    try
        println("  Installing $pkg...")
        Pkg.add(pkg)
    catch e
        println("  ⚠️  Warning: Could not install $pkg - $e")
    end
end

println("✅ Setup complete!")
println()
println("To start the annotation tool, run:")
println("  julia example.jl")
println()
println("Then open your browser to: http://localhost:8080")
