using ConditionalMoments
using Test

## Observations

const X = [1.,1.,4.,5.,6.,7]
const dt = 0.1
const ob = Observation(X,dt)

@testset "Observations" begin
    @test ob.dt == dt
    @test ob.npoints == 6

    @test_throws MethodError Observation([1.,1.,4.,5.,6.,7+2im],dt)
end

## Moments

const τ_indices = [1,3,4]
const bin_edges = LinRange(-2,2,5)
const histogramSettings = HistogramSettings(τ_indices,bin_edges)

@testset "Moment settings" begin
    @test histogramSettings.n_time_points == 3
    @test histogramSettings.n_evaluation_points == 5

    @test_throws MethodError HistogramSettings([1,2,3.1],bin_edges)
    @test_throws MethodError HistogramSettings([1,2,3+1im],bin_edges)
end

const moments = Moments(ob, histogramSettings)
@testset "Moment calculations" begin
    @test moments.observation.npoints == 6
    @test size(moments.M1) == ((3,4))
    @test size(moments.M2) == ((3,4))
    @test moments.M1[1,4] == 1.5
    @test moments.M2[1,4] == 2.25
end
