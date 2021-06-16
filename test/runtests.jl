using ConditionalMoments
using Test

@testset "First test functions" begin
    @test my_fun(2,3) == 7
    @test my_fun(2,4) == 8
    @test my_fun(3,4) == 10
    @test my_fun(10,10) == 30
end

@testset "Observations" begin
    X = [1.,1.,4.,5.,6.,7]
    ob = Observation(X,0.1)
    @test ob.dt == 0.1
    @test ob.npoints == 6
    @test ob.X == X
end
