module ConditionalMoments

export Observation, EnsembleObservation
export HistogramSettings
export Moments
export WhiteNoiseProcess
export estimateProcess

using Statistics: mean
using SliceMap

import Base: size, getindex

include("observations.jl")
include("moments.jl")
include("driftnoisefunctions.jl")


end
