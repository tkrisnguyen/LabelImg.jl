using Test
using LabelImg

@testset "LabelImg.jl" begin
    @testset "Module loads" begin
        @test isdefined(LabelImg, :Project)
        @test isdefined(LabelImg, :Annotation)
        @test isdefined(LabelImg, :create_project)
        @test isdefined(LabelImg, :save_annotations)
    end
    
    @testset "Data structures" begin
        # Test Annotation structure
        ann = LabelImg.Annotation(
            "test-id",
            "test.jpg",
            [],
            Dict{String,Any}()
        )
        @test ann.id == "test-id"
        @test ann.image_path == "test.jpg"
        @test isempty(ann.annotations)
        
        # Test Project structure
        proj = LabelImg.Project(
            "TestProject",
            String[],
            ["label1", "label2"],
            Dict{String,LabelImg.Annotation}(),
            1
        )
        @test proj.name == "TestProject"
        @test proj.labels == ["label1", "label2"]
        @test proj.current_index == 1
    end
    
    @testset "Helper functions" begin
        # Test encode_image with invalid path
        result = LabelImg.encode_image("nonexistent.jpg")
        @test result === nothing
    end
end
