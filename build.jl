#!/usr/bin/env julia

# Build script to create standalone executable using PackageCompiler

using Pkg

# Install PackageCompiler if not already installed
if !haskey(Pkg.project().dependencies, "PackageCompiler")
    println("Installing PackageCompiler...")
    Pkg.add("PackageCompiler")
end

using PackageCompiler

println("Building LabelImg executable...")
println("This may take 10-20 minutes on first build...")

# Use shorter path to avoid Windows MAX_PATH issues
# If build fails with path errors, try building to C:\LabelImg-dist
output_dir = "C:\\Users\\Thanh\\Downloads\\LabelImg-dist"

# Check if we're on Windows and path might be too long
if Sys.iswindows()
    current_dir = pwd()
    if length(current_dir) > 50
        println("\n⚠️  WARNING: Current path is long ($(length(current_dir)) chars)")
        println("   If build fails, try one of these solutions:")
        println("   1. Build to shorter path: C:\\LabelImg-dist")
        println("   2. Enable long paths in Windows (see BUILD.md)")
        println("   3. Move project to shorter path like C:\\LabelImg\n")
        
        # Ask user if they want to use C:\LabelImg-dist
        println("Would you like to build to C:\\LabelImg-dist instead? (recommended)")
        print("Type 'y' for yes, or press Enter to continue with current path: ")
        response = readline()
        if lowercase(strip(response)) == "y"
            output_dir = "C:\\LabelImg-dist"
            println("✓ Using shorter path: $output_dir")
        end
    end
end

println("\nBuilding to: $output_dir")

# Create the executable with reduced optimization to save memory
try
    create_app(
        ".",                                    # Source directory
        output_dir,                            # Output directory
        executables = ["main.jl" => "LabelImg"],  # Main script -> executable name
        # Skip precompile_execution_file - Genie doesn't work well with it
        force = true,                          # Overwrite existing build
        include_lazy_artifacts = false,        # Exclude lazy artifacts to avoid path issues
        incremental = true,                    # Use incremental compilation (less memory intensive)
        filter_stdlibs = false,                # Include all stdlibs
        cpu_target = "generic"                 # Use generic CPU target (faster compilation)
    )
    
    println("\n" * "=" ^ 60)
    println("✓ Build complete!")
    println("=" ^ 60)
    println("Executable location: $output_dir/bin/LabelImg")
    println("\nTo run:")
    if Sys.iswindows()
        println("  Windows: $(output_dir)\\bin\\LabelImg.exe")
    else
        println("  Linux/Mac: $output_dir/bin/LabelImg")
    end
    println("\nTo change port:")
    println("  LabelImg.exe 3000")
    println("=" ^ 60)
    
catch e
    println("\n" * "=" ^ 60)
    println("❌ Build failed!")
    println("=" ^ 60)
    println("Error: $e")
    println("\nTroubleshooting:")
    if Sys.iswindows()
        println("1. Try building to a shorter path:")
        println("   Set output_dir = \"C:\\\\LabelImg-dist\" in build.jl")
        println("\n2. Enable Windows Long Path Support:")
        println("   - Run PowerShell as Administrator")
        println("   - Run: New-ItemProperty -Path \"HKLM:\\SYSTEM\\CurrentControlSet\\Control\\FileSystem\" -Name \"LongPathsEnabled\" -Value 1 -PropertyType DWORD -Force")
        println("   - Restart computer")
        println("\n3. Move project to shorter path:")
        println("   - Move folder to C:\\LabelImg")
        println("   - Run build.jl from there")
    end
    println("\nFor more help, see BUILD.md")
    println("=" ^ 60)
    rethrow(e)
end
