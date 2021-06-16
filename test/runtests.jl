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
    dt = 0.1
    ob = Observation(X,dt)
    @test ob.dt == dt
    @test ob.npoints == 6
end

@testset "Observations" begin
    τ_indices = [1,3,4]
    bin_edges = LinRange(-2,2,4)
    mhs = MomentHistogramSettings(τ_indices,bin_edges)
    @test mhs.n_time_points == 3
    @test mhs.n_evaluation_points == 4
end
