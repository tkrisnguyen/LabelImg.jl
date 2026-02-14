using Test
using LabelImgJL

@testset "LabelImgJL.jl" begin
    @testset "Module loads" begin
        @test isdefined(LabelImgJL, :Project)
        @test isdefined(LabelImgJL, :Annotation)
        @test isdefined(LabelImgJL, :create_project)
        @test isdefined(LabelImgJL, :save_annotations)
    end
    
    @testset "Data structures" begin
        # Test Annotation structure
        ann = LabelImgJL.Annotation(
            "test-id",
            "test.jpg",
            [],
            Dict{String,Any}()
        )
        @test ann.id == "test-id"
        @test ann.image_path == "test.jpg"
        @test isempty(ann.annotations)
        
        # Test Project structure
        proj = LabelImgJL.Project(
            "TestProject",
            String[],
            ["label1", "label2"],
            Dict{String,LabelImgJL.Annotation}(),
            1
        )
        @test proj.name == "TestProject"
        @test proj.labels == ["label1", "label2"]
        @test proj.current_index == 1
    end
    
    @testset "Helper functions" begin
        # Test encode_image with invalid path
        result = LabelImgJL.encode_image("nonexistent.jpg")
        @test result === nothing
    end
end
