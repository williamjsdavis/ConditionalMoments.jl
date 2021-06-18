module ConditionalMoments

export Observation
export HistogramSettings
export Moments

using Statistics: mean

include("observations.jl")
include("moments.jl")



end
