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
    moments::MomentSolution
    settings::InvertSettings
end

# TODO: Think about general use cases for estimation
function WhiteNoiseProcess(moments::Moments,settings::InvertSettings)
    drift, noise, errors = makef()
    return WhiteNoiseProcess(drift,noise,errors,moments,settings)
end

function WhiteNoiseProcess(moment_sol::MomentSolution;
                           i::Integer=1,
                           settings::InvertSettings=InvertSettings())
    drift, noise, errors = estimateProcess(moment_sol,i)
    return WhiteNoiseProcess(drift,noise,errors,moment_sol,settings)
end

function estimateProcess(moment_sol::MomentSolution,i::Integer)
    τ_vector = moment_sol.observation.dt *
        moment_sol.settings.time_shift_sample_points
    drift = moment_sol.moments.M1[i,:] ./ τ_vector[i]
    noise = moment_sol.moments.M2[i,:] ./ (2*τ_vector[i])
    errors = moment_sol.errors[i,:]
    return drift, noise, errors
end
