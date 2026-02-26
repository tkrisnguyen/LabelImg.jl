# Precompilation script to speed up startup time
# This runs during build to precompile common operations

include("src/LabelImg.jl")

println("Running precompilation script...")

# Load the module functions to trigger compilation
try
    # Trigger loading of key modules and functions
    LabelImg.start
    
    println("Precompilation complete!")
catch e
    println("Precompilation warning: ", e)
end
