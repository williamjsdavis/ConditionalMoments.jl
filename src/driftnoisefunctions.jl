abstract type FitSettings end

struct InvertSettings <: FitSettings end

#TODO: Add other fit settings

abstract type StochasticProcess end

struct WhiteNoiseProcess{S<:Real,T<:AbstractVector{S}}
    drift::T
    noise::T
    errors::T
    moments::Moments
    settings::InvertSettings
end

function WhiteNoiseProcess(moments::Moments,settings::InvertSettings)
    drift, noise, errors = makef()
    return WhiteNoiseProcess(drift,noise,errors,moments,settings)
end

function WhiteNoiseProcess(moments::Moments,i::Integer=1,settings::InvertSettings)
    drift, noise, errors = estimateProcess(moments,i)
    return WhiteNoiseProcess(drift,noise,errors,moments,settings)
end

function estimateProcess(moments::Moments,i::Integer)
    τ_vector = moments.observation.dt * moments.evaluation_points
    drift = moments.M1[i,:] ./ τ_vector
    noise = moments.M2[i,:] ./ τ_vector
    return drift, noise, errors
end
