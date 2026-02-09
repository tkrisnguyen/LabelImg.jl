#!/usr/bin/env julia

# Build script to create standalone executable using PackageCompiler

using Pkg

# Install PackageCompiler if not already installed
if !haskey(Pkg.project().dependencies, "PackageCompiler")
    println("Installing PackageCompiler...")
    Pkg.add("PackageCompiler")
end

using PackageCompiler

println("Building LabelImgJL executable...")
println("This may take 10-20 minutes on first build...")

# Create the executable
create_app(
    ".",                                    # Source directory
    "LabelImgJL-dist",                     # Output directory
    executables = ["main.jl" => "LabelImgJL"],  # Main script -> executable name
    precompile_execution_file = "precompile.jl",  # Optional: for faster startup
    force = true,                          # Overwrite existing build
    include_lazy_artifacts = true,         # Include all artifacts
    filter_stdlibs = false                 # Include all standard libraries
)

println("\n" * "=" ^ 60)
println("Build complete!")
println("=" ^ 60)
println("Executable location: LabelImgJL-dist/bin/LabelImgJL")
println("\nTo run:")
println("  Windows: .\\LabelImgJL-dist\\bin\\LabelImgJL.exe")
println("  Linux/Mac: ./LabelImgJL-dist/bin/LabelImgJL")
println("\nTo change port:")
println("  LabelImgJL.exe 3000")
println("=" ^ 60)
