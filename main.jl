#!/usr/bin/env julia

# Main entry point for compiled executable

include("src/LabelImgJL.jl")

function main()
    # Parse command line arguments
    port = 8080
    if length(ARGS) > 0
        try
            port = parse(Int, ARGS[1])
        catch
            println("Invalid port number. Using default port 8080")
        end
    end
    
    println("=" ^ 60)
    println("LabelImgJL - Image Annotation Tool")
    println("=" ^ 60)
    println("Starting server on port $port...")
    println("Open your browser and go to: http://localhost:$port")
    println("Press Ctrl+C to stop the server")
    println("=" ^ 60)
    
    # Start the server
    LabelImgJL.start(port)
end

# Run main if this is the entry point
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
