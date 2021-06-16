using ConditionalMoments
using Test

my_fun(10,10)

@testset "ConditionalMoments.jl" begin
    @test my_fun(2,3) == 7
    @test my_fun(2,4) == 8
    @test my_fun(3,4) == 10
    @test my_fun(10,10) == 30
end
