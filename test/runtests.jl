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

## Drift and noise functions

const model1 = WhiteNoiseProcess(moments)
const model2 = WhiteNoiseProcess(moments,i=2)

@testset "Drift and noise calculations" begin
    @test size(model1.drift) == (4,)
    @test size(model1.noise) == (4,)
    @test size(model1.errors) == (4,)
    @test size(model2.drift) == (4,)
    @test size(model2.noise) == (4,)
    @test size(model2.errors) == (4,)
    @test ~isnan(model1.drift[4])
    @test ~isnan(model2.drift[4])
    @test ~isnan(model1.noise[4])
    @test ~isnan(model2.noise[4])
end

## Ensemble observations

const X_ensemble = repeat(X,1,2)

ensemble_ob = EnsembleObservation(X_ensemble,dt)

@testset "Ensemble observations" begin
    @test ensemble_ob[3] == 4.0
    @test ensemble_ob[:,1] == X
    @test ensemble_ob[:,2] == X
    @test ensemble_ob[3,:] == [4.0,4.0]
    @test ensemble_ob[:] == X_ensemble
    @test ensemble_ob.dt == dt
    @test ensemble_ob.npoints == 18
    @test ensemble_ob.nsample == 2

    @test_throws MethodError Observation([1.,1.,4.,5.,6.,7+2im],dt)
end

## Ensemble moments

const ensemble_moments = Moments(ensemble_ob, histogramSettings)
@testset "Mapping moments" begin
    @test ensemble_moments.observation.npoints == 18
    @test ensemble_moments.observation.nsample == 2
    @test size(ensemble_moments.M1) == (3,4)
    @test size(ensemble_moments.M2) == (3,4)
    #@test size(ensemble_moments.errors) == (3,4)
    @test ensemble_moments.M1[2,4] == -4.5
    @test ensemble_moments.M2[2,4] == 0.25
end

## Larger test

const t = 0:0.001:200
const dt_large = t.step.hi
const X_large = exp.(-t) .*
    cumsum(exp.(t) .* (sqrt(dt_large)*pushfirst!(randn(length(t)-1),0)))
const ob_large = Observation(X_large,dt_large)

@testset "Larger observation" begin
    @test ob_large[ob_large .> 3] == X_large[X_large .> 3]
    @test ob_large[(ob_large .> 3)'] == X_large[X_large .> 3]
    @test ob_large[:] == X_large
    @test ob_large.dt == dt_large
    @test ob_large.npoints == length(t)
end

const τ_indices_large = 1:20
const τ_vec = dt_large*τ_indices_large
const bin_edges_large = LinRange(-1,1,10)
const histogramSettings_large =
        HistogramSettings(τ_indices_large,bin_edges_large)
const moments_large = Moments(ob_large, histogramSettings_large)

const M1_τ = moments_large.M1 ./ τ_vec
const M2_τ = moments_large.M2 ./ (2*τ_vec)

@testset "Larger moments" begin
    @test moments_large.observation.npoints == length(t)
    expected_size = (length(τ_indices_large),length(bin_edges_large)-1)
    @test size(moments_large.M1) == expected_size
    @test size(moments_large.M2) == expected_size
    @test size(moments_large.errors) == expected_size
end

const model1_large = WhiteNoiseProcess(moments_large)
const model2_large = WhiteNoiseProcess(moments_large,i=2)

@testset "Larger drift and noise functions" begin
    expected_length = length(bin_edges_large)-1
    @test size(model1_large.drift) == (expected_length,)
    @test size(model1_large.noise) == (expected_length,)
    @test size(model1_large.errors) == (expected_length,)
    @test size(model2_large.drift) == (expected_length,)
    @test size(model2_large.noise) == (expected_length,)
    @test size(model2_large.errors) == (expected_length,)
    @test ~isnan(model1_large.drift[4])
    @test ~isnan(model2_large.drift[4])
    @test ~isnan(model1_large.noise[4])
    @test ~isnan(model2_large.noise[4])
end
