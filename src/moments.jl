abstract type MomentSettings end

"Moment calculation settings for histogram methods"
struct HistogramSettings{S<:Integer,T<:AbstractVector{S},S1<:Real,T1<:AbstractVector{S1}} <: MomentSettings
    time_shift_sample_points::T
    bin_edges::T1
    n_time_points
    n_evaluation_points
end

function HistogramSettings(time_shift_sample_points,bin_edges)
    n_time_points = length(time_shift_sample_points)
    n_evaluation_points = length(bin_edges)
    return HistogramSettings(time_shift_sample_points,
                             bin_edges,
                             n_time_points,
                             n_evaluation_points)
end

"Moments structure"
struct Moments
    M1
    M2
    observation::Observation
    evaluation_points
    settings::MomentSettings
end

function Moments(observation::Observation,settings::MomentSettings)
    M1est, M2est, evaluation_points = build_moments(observation, settings)
    return Moments(M1est,M2est,observation,evaluation_points,settings)
end

function make_grid(tau_vector::AbstractVector,edge_vector::LinRange)
    return broadcast((x,y)->(x,y),tau_vector,(1:edge_vector.lendiv)')
end

center(x::LinRange) = (x[1:end-1]+x[2:end])/2

"Calculating moments with histograms"
function build_moments(observation::Observation, settings::MomentSettings)
    ti_grid = make_grid(settings.time_shift_sample_points,
                        settings.bin_edges)

    M1est,M2est = moments_map(observation.X,
                              settings.time_shift_sample_points,
                              settings.bin_edges,
                              ti_grid)

    evaluation_points = center(settings.bin_edges)

    return M1est, M2est, evaluation_points
end

function get_moments(X, iX, tau)
    inc = X[iX .+ tau] .- X[iX]
    M1 = mean(inc)
    M2 = mean((inc .- M1).^2)
    return M1, M2
end
find_bin(r::LinRange,x::Real) = floor(Int, ((x-r.start)/(r.stop-r.start)*r.lendiv + 1))
in_range(r::LinRange,x::Real) = (x >= r.start) && (x <= r.stop)
function moments_map(X::AbstractVector,tau_vector,edge_vector::LinRange,ti_grid)

    bin_index = map(X) do y
        in_range(edge_vector,y) ? find_bin(edge_vector,y) : 0
    end

    bin_groups = map(1:edge_vector.lendiv) do i
        findall(bin_index[1:end-maximum(tau_vector)].==i)
    end

    M1M2 = map(ti_grid) do ti
        get_moments(X,bin_groups[ti[2]],ti[1])
    end

    M1 = broadcast(first,M1M2)
    M2 = broadcast(last,M1M2)

    return M1, M2
end
