using Test
using LabelImg

@testset "LabelImg.jl" begin
    # Basic existence tests
    @test isdefined(LabelImg, :Project)
    @test isdefined(LabelImg, :Annotation)
    @test isdefined(LabelImg, :create_project)
    @test isdefined(LabelImg, :save_annotations)
    @test isdefined(LabelImg, :encode_image)
end
