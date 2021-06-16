using ConditionalMoments
using Test

my_fun(2,4)

@testset "ConditionalMoments.jl" begin
    @test my_fun(2,3) == 7
    @test my_fun(2,4) == 8
end
