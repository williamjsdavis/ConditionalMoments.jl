module ConditionalMoments

export Observation
export HistogramSettings
export Moments

using Statistics: mean

import Base: size, getindex

include("observations.jl")
include("moments.jl")



end
