using ConditionalMoments
using Test

## Observations

const X = [1.,1.,4.,5.,6.,7,1.,2.,4.,5.,6.,7,3.,1.,4.,5.,6.,7]
const dt = 0.1
const ob = Observation(X,dt)

@testset "Observations" begin
    @test ob[3] == 4.0
    @test ob[ob .> 3] == X[X .> 3]
    @test ob[(ob .> 3)'] == X[X .> 3]
    @test ob[:] == X
    @test ob.dt == dt
    @test ob.npoints == 18

    @test_throws MethodError Observation([1.,1.,4.,5.,6.,7+2im],dt)
end

## Moments

const τ_indices = [1,3,4]
const bin_edges = LinRange(1.5,6.5,5)
const histogramSettings = HistogramSettings(τ_indices,bin_edges)

@testset "Moment settings" begin
    @test histogramSettings.n_time_points == 3
    @test histogramSettings.n_evaluation_points == 5

    @test_throws MethodError HistogramSettings([1,2,3.1],bin_edges)
    @test_throws MethodError HistogramSettings([1,2,3+1im],bin_edges)
end

const moments = Moments(ob, histogramSettings)
@testset "Moment calculations" begin
    @test moments.observation.npoints == 18
    @test size(moments.M1) == (3,4)
    @test size(moments.M2) == (3,4)
    @test size(moments.errors) == (3,4)
    @test moments.M1[2,4] == -4.5
    @test moments.M2[2,4] == 0.25
end

## Larger test

const t = 0:0.001:200
const dt = t.step.hi
const X = exp.(-t) .*
    cumsum(exp.(t) .* (sqrt(dt)*pushfirst!(randn(length(t)-1),0)))
const ob = Observation(X,dt)

@testset "Larger observation" begin
    @test ob[ob .> 3] == X[X .> 3]
    @test ob[(ob .> 3)'] == X[X .> 3]
    @test ob[:] == X
    @test ob.dt == dt
    @test ob.npoints == length(t)
end

const τ_indices2 = 1:20
const τ_vec = dt*τ_indices2
const bin_edges2 = LinRange(-1,1,10)
const histogramSettings2 = HistogramSettings(τ_indices2,bin_edges2)
const moments = Moments(ob, histogramSettings2)

const M1_τ = moments.M1 ./ τ_vec
const M2_τ = moments.M2 ./ (2*τ_vec)

@testset "Larger moments" begin
    @test moments.observation.npoints == length(t)
    @test size(moments.M1) == (length(τ_indices2),length(bin_edges2)-1)
    @test size(moments.M2) == (length(τ_indices2),length(bin_edges2)-1)
    @test size(moments.errors) == (length(τ_indices2),length(bin_edges2)-1)
end
