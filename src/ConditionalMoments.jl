module ConditionalMoments

export my_fun
export Observation
export MomentHistogramSettings
export Moments

using Statistics: mean

include("testfun.jl")
include("observations.jl")
include("moments.jl")



end
