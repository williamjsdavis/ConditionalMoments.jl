using ConditionalMoments
using Test

@testset "First test functions" begin
    @test my_fun(2,3) == 7
    @test my_fun(2,4) == 8
    @test my_fun(3,4) == 10
    @test my_fun(10,10) == 30
end

## Observations

X = [1.,1.,4.,5.,6.,7]
dt = 0.1
ob = Observation(X,dt)

@testset "Observations" begin
    @test ob.dt == dt
    @test ob.npoints == 6
end

## Moments

τ_indices = [1,3,4]
bin_edges = LinRange(-2,2,5)
histogram_settings = MomentHistogramSettings(τ_indices,bin_edges)

@testset "Moment settings" begin
    @test histogram_settings.n_time_points == 3
    @test histogram_settings.n_evaluation_points == 5
end

moments = Moments(ob, histogram_settings)
@testset "Moment calculations" begin
    @test moments.observation.npoints == 6
    @test size(moments.M1) == ((3,4))
    @test size(moments.M2) == ((3,4))
    @test moments.M1[1,4] == 1.5
    @test moments.M2[1,4] == 2.25
end
