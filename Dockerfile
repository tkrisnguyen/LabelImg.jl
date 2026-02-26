FROM julia:1.12

WORKDIR /app

# Copy project files
COPY Project.toml .
COPY Manifest.toml* ./
COPY src/ ./src/
COPY example.jl .

# Install dependencies
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'

# Expose port
EXPOSE 8080

# Set environment
ENV JULIA_NUM_THREADS=auto
ENV JULIA_PROJECT=@.

# Start server
CMD ["julia", "-e", "include(\"src/LabelImg.jl\"); LabelImg.start(8080)"]
