module Interface

using Genie, Genie.Router, Genie.Renderer.Html, Genie.Renderer.Json
using JSON3
using Images, FileIO
using Base64

# Data structures
mutable struct Annotation
    id::String
    image_path::String
    annotations::Vector{Dict{String,Any}}
    metadata::Dict{String,Any}
end

mutable struct Project
    name::String
    images::Vector{String}
    labels::Vector{String}
    annotations::Dict{String,Annotation}
    current_index::Int
end

# Global state
const PROJECTS = Dict{String,Project}()
const CURRENT_PROJECT = Ref{Union{Nothing,String}}(nothing)

# Helper functions
function encode_image(image_path::String)
    try
        img = load(image_path)
        io = IOBuffer()
        save(Stream(format"PNG", io), img)
        return "data:image/png;base64," * base64encode(take!(io))
    catch e
        @error "Error encoding image" exception=e
        return nothing
    end
end

function create_project(name::String, image_dir::String, labels::Vector{String})
    images = []
    for ext in ["*.jpg", "*.jpeg", "*.png", "*.bmp", "*.gif"]
        append!(images, readdir(image_dir, join=true) |> 
                xs -> filter(x -> occursin(Regex(replace(ext, "*" => ".*"), "i"), x), xs))
    end
    
    project = Project(
        name,
        images,
        labels,
        Dict{String,Annotation}(),
        1
    )
    
    PROJECTS[name] = project
    CURRENT_PROJECT[] = name
    return project
end

function save_annotations(project::Project, output_path::String)
    data = Dict(
        "project" => project.name,
        "labels" => project.labels,
        "annotations" => [
            Dict(
                "image" => ann.image_path,
                "annotations" => ann.annotations,
                "metadata" => ann.metadata
            ) for ann in values(project.annotations)
        ]
    )
    
    open(output_path, "w") do io
        JSON3.pretty(io, data)
    end
end

# Routes
route("/") do
    html("""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LabelImgJL - Image Annotation Tool</title>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                background: #f5f5f5;
                color: #333;
            }
            
            .header {
                background: #2c3e50;
                color: white;
                padding: 1rem 2rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            
            .header h1 {
                font-size: 1.5rem;
                font-weight: 600;
            }
            
            .container {
                display: flex;
                height: calc(100vh - 60px);
            }
            
            .sidebar {
                width: 280px;
                background: white;
                border-right: 1px solid #e0e0e0;
                overflow-y: auto;
                padding: 1rem;
            }
            
            .main-content {
                flex: 1;
                display: flex;
                flex-direction: column;
                background: #fafafa;
            }
            
            .toolbar {
                background: white;
                border-bottom: 1px solid #e0e0e0;
                padding: 0.75rem 1.5rem;
                display: flex;
                gap: 1rem;
                align-items: center;
            }
            
            .canvas-container {
                flex: 1;
                position: relative;
                overflow: auto;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 2rem;
            }
            
            #canvas {
                border: 2px solid #ddd;
                cursor: crosshair;
                max-width: 100%;
                max-height: 100%;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }
            
            .btn {
                padding: 0.5rem 1rem;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.9rem;
                transition: all 0.2s;
                background: #3498db;
                color: white;
            }
            
            .btn:hover {
                background: #2980b9;
                transform: translateY(-1px);
            }
            
            .btn.active {
                background: #e74c3c;
            }
            
            .btn-secondary {
                background: #95a5a6;
            }
            
            .btn-secondary:hover {
                background: #7f8c8d;
            }
            
            .btn-success {
                background: #27ae60;
            }
            
            .btn-success:hover {
                background: #229954;
            }
            
            .label-list {
                margin-top: 1rem;
            }
            
            .label-item {
                padding: 0.75rem;
                margin: 0.5rem 0;
                background: #ecf0f1;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.2s;
                border-left: 4px solid transparent;
            }
            
            .label-item:hover {
                background: #d5dbdb;
            }
            
            .label-item.selected {
                background: #3498db;
                color: white;
                border-left-color: #2980b9;
            }
            
            .annotation-list {
                margin-top: 1.5rem;
            }
            
            .annotation-item {
                padding: 0.5rem;
                margin: 0.3rem 0;
                background: #fff;
                border: 1px solid #e0e0e0;
                border-radius: 4px;
                font-size: 0.85rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .delete-btn {
                background: #e74c3c;
                color: white;
                border: none;
                padding: 0.25rem 0.5rem;
                border-radius: 3px;
                cursor: pointer;
                font-size: 0.75rem;
            }
            
            .delete-btn:hover {
                background: #c0392b;
            }
            
            .navigation {
                padding: 1rem 1.5rem;
                background: white;
                border-top: 1px solid #e0e0e0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .section-title {
                font-size: 0.9rem;
                font-weight: 600;
                color: #7f8c8d;
                margin-bottom: 0.5rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            input[type="text"], input[type="file"] {
                width: 100%;
                padding: 0.5rem;
                border: 1px solid #ddd;
                border-radius: 4px;
                margin: 0.5rem 0;
            }
            
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                align-items: center;
                justify-content: center;
            }
            
            .modal.active {
                display: flex;
            }
            
            .modal-content {
                background: white;
                padding: 2rem;
                border-radius: 8px;
                max-width: 500px;
                width: 90%;
                box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            }
            
            .tool-group {
                display: flex;
                gap: 0.5rem;
                padding-right: 1rem;
                border-right: 1px solid #e0e0e0;
            }
            
            .info-badge {
                background: #ecf0f1;
                padding: 0.25rem 0.75rem;
                border-radius: 12px;
                font-size: 0.85rem;
                color: #555;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>🏷️ LabelImgJL - Image Annotation Tool</h1>
        </div>
        
        <div class="container">
            <div class="sidebar">
                <div class="section-title">📁 Project</div>
                <button class="btn btn-success" onclick="showProjectModal()" style="width: 100%; margin-bottom: 1rem;">
                    New Project
                </button>
                
                <div class="section-title">🎨 Labels</div>
                <div id="labelList" class="label-list"></div>
                
                <div class="section-title">📝 Annotations</div>
                <div id="annotationList" class="annotation-list"></div>
            </div>
            
            <div class="main-content">
                <div class="toolbar">
                    <div class="tool-group">
                        <button class="btn" id="rectBtn" onclick="setTool('rect')">▭ Rectangle</button>
                        <button class="btn" id="polygonBtn" onclick="setTool('polygon')">⬢ Polygon</button>
                        <button class="btn" id="pointBtn" onclick="setTool('point')">● Point</button>
                    </div>
                    <button class="btn btn-secondary" onclick="clearCurrent()">Clear</button>
                    <button class="btn btn-success" onclick="saveAnnotations()">💾 Save</button>
                    <div style="flex: 1;"></div>
                    <div class="info-badge" id="imageInfo">No image loaded</div>
                </div>
                
                <div class="canvas-container">
                    <canvas id="canvas"></canvas>
                </div>
                
                <div class="navigation">
                    <button class="btn btn-secondary" onclick="prevImage()">⬅ Previous</button>
                    <span id="imageCounter">0 / 0</span>
                    <button class="btn btn-secondary" onclick="nextImage()">Next ➡</button>
                </div>
            </div>
        </div>
        
        <!-- Project Modal -->
        <div id="projectModal" class="modal">
            <div class="modal-content">
                <h2 style="margin-bottom: 1.5rem;">Create New Project</h2>
                <label>Project Name:</label>
                <input type="text" id="projectName" placeholder="My Annotation Project">
                
                <label>Image Directory:</label>
                <input type="text" id="imageDir" placeholder="/path/to/images">
                
                <label>Labels (comma separated):</label>
                <input type="text" id="labelsInput" placeholder="cat, dog, person">
                
                <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                    <button class="btn btn-success" onclick="createProject()">Create</button>
                    <button class="btn btn-secondary" onclick="hideProjectModal()">Cancel</button>
                </div>
            </div>
        </div>
        
        <script>
            let canvas, ctx;
            let currentTool = 'rect';
            let isDrawing = false;
            let startX, startY;
            let currentImage = null;
            let annotations = [];
            let currentLabel = null;
            let polygonPoints = [];
            let project = null;
            
            // Initialize
            document.addEventListener('DOMContentLoaded', function() {
                canvas = document.getElementById('canvas');
                ctx = canvas.getContext('2d');
                
                canvas.addEventListener('mousedown', handleMouseDown);
                canvas.addEventListener('mousemove', handleMouseMove);
                canvas.addEventListener('mouseup', handleMouseUp);
                canvas.addEventListener('click', handleClick);
            });
            
            function setTool(tool) {
                currentTool = tool;
                document.querySelectorAll('.toolbar .btn').forEach(btn => btn.classList.remove('active'));
                document.getElementById(tool + 'Btn').classList.add('active');
                polygonPoints = [];
            }
            
            function handleMouseDown(e) {
                if (currentTool === 'polygon' || !currentLabel) return;
                
                const rect = canvas.getBoundingClientRect();
                startX = e.clientX - rect.left;
                startY = e.clientY - rect.top;
                isDrawing = true;
            }
            
            function handleMouseMove(e) {
                if (!isDrawing || currentTool === 'polygon') return;
                
                const rect = canvas.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                redrawCanvas();
                
                ctx.strokeStyle = '#3498db';
                ctx.lineWidth = 2;
                ctx.setLineDash([5, 5]);
                
                if (currentTool === 'rect') {
                    ctx.strokeRect(startX, startY, x - startX, y - startY);
                }
                
                ctx.setLineDash([]);
            }
            
            function handleMouseUp(e) {
                if (!isDrawing || currentTool === 'polygon') return;
                
                const rect = canvas.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                if (currentTool === 'rect' && currentLabel) {
                    const annotation = {
                        type: 'rectangle',
                        label: currentLabel,
                        x: Math.min(startX, x),
                        y: Math.min(startY, y),
                        width: Math.abs(x - startX),
                        height: Math.abs(y - startY),
                        color: getRandomColor()
                    };
                    annotations.push(annotation);
                    updateAnnotationList();
                }
                
                isDrawing = false;
                redrawCanvas();
            }
            
            function handleClick(e) {
                if (currentTool === 'point' && currentLabel) {
                    const rect = canvas.getBoundingClientRect();
                    const x = e.clientX - rect.left;
                    const y = e.clientY - rect.top;
                    
                    annotations.push({
                        type: 'point',
                        label: currentLabel,
                        x: x,
                        y: y,
                        color: getRandomColor()
                    });
                    updateAnnotationList();
                    redrawCanvas();
                } else if (currentTool === 'polygon' && currentLabel) {
                    const rect = canvas.getBoundingClientRect();
                    const x = e.clientX - rect.left;
                    const y = e.clientY - rect.top;
                    
                    polygonPoints.push({x, y});
                    redrawCanvas();
                    
                    // Double-click to finish polygon
                    if (e.detail === 2 && polygonPoints.length > 2) {
                        annotations.push({
                            type: 'polygon',
                            label: currentLabel,
                            points: [...polygonPoints],
                            color: getRandomColor()
                        });
                        polygonPoints = [];
                        updateAnnotationList();
                        redrawCanvas();
                    }
                }
            }
            
            function redrawCanvas() {
                if (!currentImage) return;
                
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                ctx.drawImage(currentImage, 0, 0, canvas.width, canvas.height);
                
                // Draw existing annotations
                annotations.forEach(ann => {
                    ctx.strokeStyle = ann.color;
                    ctx.fillStyle = ann.color + '33';
                    ctx.lineWidth = 2;
                    
                    if (ann.type === 'rectangle') {
                        ctx.strokeRect(ann.x, ann.y, ann.width, ann.height);
                        ctx.fillRect(ann.x, ann.y, ann.width, ann.height);
                        ctx.fillStyle = ann.color;
                        ctx.fillText(ann.label, ann.x, ann.y - 5);
                    } else if (ann.type === 'point') {
                        ctx.beginPath();
                        ctx.arc(ann.x, ann.y, 5, 0, 2 * Math.PI);
                        ctx.fill();
                        ctx.stroke();
                        ctx.fillText(ann.label, ann.x + 10, ann.y);
                    } else if (ann.type === 'polygon') {
                        ctx.beginPath();
                        ctx.moveTo(ann.points[0].x, ann.points[0].y);
                        for (let i = 1; i < ann.points.length; i++) {
                            ctx.lineTo(ann.points[i].x, ann.points[i].y);
                        }
                        ctx.closePath();
                        ctx.stroke();
                        ctx.fill();
                        ctx.fillStyle = ann.color;
                        ctx.fillText(ann.label, ann.points[0].x, ann.points[0].y - 5);
                    }
                });
                
                // Draw current polygon points
                if (polygonPoints.length > 0) {
                    ctx.strokeStyle = '#3498db';
                    ctx.fillStyle = '#3498db';
                    ctx.lineWidth = 2;
                    
                    polygonPoints.forEach(p => {
                        ctx.beginPath();
                        ctx.arc(p.x, p.y, 3, 0, 2 * Math.PI);
                        ctx.fill();
                    });
                    
                    if (polygonPoints.length > 1) {
                        ctx.beginPath();
                        ctx.moveTo(polygonPoints[0].x, polygonPoints[0].y);
                        for (let i = 1; i < polygonPoints.length; i++) {
                            ctx.lineTo(polygonPoints[i].x, polygonPoints[i].y);
                        }
                        ctx.stroke();
                    }
                }
            }
            
            function getRandomColor() {
                const colors = ['#e74c3c', '#3498db', '#2ecc71', '#f39c12', '#9b59b6', '#1abc9c'];
                return colors[Math.floor(Math.random() * colors.length)];
            }
            
            function selectLabel(label) {
                currentLabel = label;
                document.querySelectorAll('.label-item').forEach(item => {
                    item.classList.remove('selected');
                });
                event.target.classList.add('selected');
            }
            
            function updateAnnotationList() {
                const list = document.getElementById('annotationList');
                list.innerHTML = annotations.map((ann, i) => 
                    `<div class="annotation-item">
                        <span>${ann.type}: ${ann.label}</span>
                        <button class="delete-btn" onclick="deleteAnnotation(${i})">✕</button>
                    </div>`
                ).join('');
            }
            
            function deleteAnnotation(index) {
                annotations.splice(index, 1);
                updateAnnotationList();
                redrawCanvas();
            }
            
            function clearCurrent() {
                annotations = [];
                polygonPoints = [];
                updateAnnotationList();
                redrawCanvas();
            }
            
            function showProjectModal() {
                document.getElementById('projectModal').classList.add('active');
            }
            
            function hideProjectModal() {
                document.getElementById('projectModal').classList.remove('active');
            }
            
            async function createProject() {
                const name = document.getElementById('projectName').value;
                const dir = document.getElementById('imageDir').value;
                const labels = document.getElementById('labelsInput').value.split(',').map(s => s.trim());
                
                const response = await fetch('/api/project/create', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({name, image_dir: dir, labels})
                });
                
                const data = await response.json();
                if (data.success) {
                    project = data.project;
                    updateLabelList(labels);
                    loadImage(0);
                    hideProjectModal();
                }
            }
            
            function updateLabelList(labels) {
                const list = document.getElementById('labelList');
                list.innerHTML = labels.map(label => 
                    `<div class="label-item" onclick="selectLabel('${label}')">${label}</div>`
                ).join('');
            }
            
            async function loadImage(index) {
                const response = await fetch(`/api/image/${index}`);
                const data = await response.json();
                
                if (data.image) {
                    const img = new Image();
                    img.onload = function() {
                        canvas.width = img.width;
                        canvas.height = img.height;
                        currentImage = img;
                        annotations = data.annotations || [];
                        redrawCanvas();
                        updateAnnotationList();
                        document.getElementById('imageInfo').textContent = data.filename;
                        document.getElementById('imageCounter').textContent = 
                            `${index + 1} / ${data.total}`;
                    };
                    img.src = data.image;
                }
            }
            
            function nextImage() {
                if (project) {
                    fetch('/api/image/next').then(r => r.json()).then(data => {
                        if (data.index !== undefined) loadImage(data.index);
                    });
                }
            }
            
            function prevImage() {
                if (project) {
                    fetch('/api/image/prev').then(r => r.json()).then(data => {
                        if (data.index !== undefined) loadImage(data.index);
                    });
                }
            }
            
            async function saveAnnotations() {
                const response = await fetch('/api/annotations/save', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({annotations})
                });
                
                const data = await response.json();
                alert(data.message || 'Annotations saved!');
            }
        </script>
    </body>
    </html>
    """)
end

# API Routes
route("/api/project/create", method = POST) do
    payload = jsonpayload()
    name = payload["name"]
    image_dir = payload["image_dir"]
    labels = payload["labels"]
    
    try
        project = create_project(name, image_dir, labels)
        json(Dict("success" => true, "project" => Dict(
            "name" => project.name,
            "image_count" => length(project.images),
            "labels" => project.labels
        )))
    catch e
        json(Dict("success" => false, "error" => string(e)))
    end
end

route("/api/image/:index::Int") do
    if isnothing(CURRENT_PROJECT[])
        return json(Dict("error" => "No project loaded"))
    end
    
    project = PROJECTS[CURRENT_PROJECT[]]
    index = payload(:index) + 1  # Convert from 0-based to 1-based
    
    if index < 1 || index > length(project.images)
        return json(Dict("error" => "Invalid index"))
    end
    
    image_path = project.images[index]
    encoded = encode_image(image_path)
    
    # Get existing annotations if any
    ann = get(project.annotations, image_path, nothing)
    annotations = isnothing(ann) ? [] : ann.annotations
    
    json(Dict(
        "image" => encoded,
        "filename" => basename(image_path),
        "annotations" => annotations,
        "total" => length(project.images)
    ))
end

route("/api/image/next") do
    if isnothing(CURRENT_PROJECT[])
        return json(Dict("error" => "No project loaded"))
    end
    
    project = PROJECTS[CURRENT_PROJECT[]]
    project.current_index = min(project.current_index + 1, length(project.images))
    json(Dict("index" => project.current_index - 1))
end

route("/api/image/prev") do
    if isnothing(CURRENT_PROJECT[])
        return json(Dict("error" => "No project loaded"))
    end
    
    project = PROJECTS[CURRENT_PROJECT[]]
    project.current_index = max(project.current_index - 1, 1)
    json(Dict("index" => project.current_index - 1))
end

route("/api/annotations/save", method = POST) do
    if isnothing(CURRENT_PROJECT[])
        return json(Dict("error" => "No project loaded"))
    end
    
    payload = jsonpayload()
    annotations = payload["annotations"]
    
    project = PROJECTS[CURRENT_PROJECT[]]
    image_path = project.images[project.current_index]
    
    ann = Annotation(
        string(hash(image_path)),
        image_path,
        annotations,
        Dict("timestamp" => string(now()))
    )
    
    project.annotations[image_path] = ann
    
    # Save to file
    try
        output_path = joinpath(dirname(image_path), "annotations_$(project.name).json")
        save_annotations(project, output_path)
        json(Dict("success" => true, "message" => "Annotations saved successfully!"))
    catch e
        json(Dict("success" => false, "error" => string(e)))
    end
end

# Start server
function start(port::Int=8080)
    Genie.config.run_as_server = true
    Genie.config.server_port = port
    Genie.config.server_host = "0.0.0.0"
    
    @info "Starting LabelImgJL server on http://localhost:$port"
    startup()
end

end # module
