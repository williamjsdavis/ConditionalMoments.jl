module ConditionalMoments

export Observation, EnsembleObservation
export HistogramSettings
export Moments, MomentSolution
export WhiteNoiseProcess
export estimateProcess

using Statistics: mean
using SliceMap

import Base: size, getindex

include("observations.jl")
include("moments.jl")
include("driftnoisefunctions.jl")

#X = [1.,1.,4.,5.,6.,7,1.,2.,4.,5.,6.,7,3.,1.,4.,5.,6.,7]
#X_ensemble = repeat(X,1,2)
#ensemble_ob = EnsembleObservation(X_ensemble,0.1)
#histogramSettings = HistogramSettings( [1,3,4],LinRange(1.5,6.5,5))
#ensemble_moments = Moments(ensemble_ob, histogramSettings)
#include("moments.jl")

end
