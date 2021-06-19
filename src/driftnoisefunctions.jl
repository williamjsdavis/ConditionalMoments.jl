abstract type FitSettings end

struct InvertSettings <: FitSettings end

#TODO: Add other fit settings
#TODO: Include settings for noise definitions (e.g. variance = 1 or sqrt2 etc)

abstract type StochasticProcess end

#TODO: Add what setting was used (i.e. what i index)
struct WhiteNoiseProcess{S<:Real,T<:AbstractVector{S}}
    drift::T
    noise::T
    errors::T
    moments::Moments
    settings::InvertSettings
end

# TODO: Think about general use cases for estimation
function WhiteNoiseProcess(moments::Moments,settings::InvertSettings)
    drift, noise, errors = makef()
    return WhiteNoiseProcess(drift,noise,errors,moments,settings)
end

function WhiteNoiseProcess(moments::Moments;
                           i::Integer=1,
                           settings::InvertSettings=InvertSettings())
    drift, noise, errors = estimateProcess(moments,i)
    return WhiteNoiseProcess(drift,noise,errors,moments,settings)
end

function estimateProcess(moments::Moments,i::Integer)
    τ_vector = moments.observation.dt *
        moments.settings.time_shift_sample_points
    drift = moments.M1[i,:] ./ τ_vector[i]
    noise = moments.M2[i,:] ./ (2*τ_vector[i])
    errors = moments.errors[i,:]
    return drift, noise, errors
end
