module ConditionalMoments

export Observation
export MomentHistogramSettings
export Moments
export build_moments, make_grid

using Statistics: mean

include("observations.jl")
include("moments.jl")



end
