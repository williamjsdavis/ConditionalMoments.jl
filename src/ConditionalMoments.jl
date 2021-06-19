module ConditionalMoments

export Observation
export HistogramSettings
export Moments
export WhiteNoiseProcess
export estimateProcess

using Statistics: mean

import Base: size, getindex

include("observations.jl")
include("moments.jl")
include("driftnoisefunctions.jl")


end
