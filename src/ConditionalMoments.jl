module ConditionalMoments

export Observation
export MomentHistogramSettings
export Moments

using Statistics: mean

include("observations.jl")
include("moments.jl")



end
