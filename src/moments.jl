abstract type MomentSettings end

"Moment calculation settings for histogram methods"
struct HistogramSettings{S<:Integer,T<:AbstractVector{S},S1<:Real,T1<:AbstractVector{S1}} <: MomentSettings
    time_shift_sample_points::T
    bin_edges::T1
    ti_grid
    n_time_points
    n_evaluation_points
end

function HistogramSettings(time_shift_sample_points,bin_edges)
    n_time_points = length(time_shift_sample_points)
    n_evaluation_points = length(bin_edges)
    ti_grid = make_grid(time_shift_sample_points,
                        bin_edges)
    return HistogramSettings(time_shift_sample_points,
                             bin_edges,
                             ti_grid,
                             n_time_points,
                             n_evaluation_points)
end

struct Moments{T<:AbstractFloat}
    M1::Matrix{T}
    M2::Matrix{T}
end

"Moments structure"
struct MomentSolution{T<:AbstractFloat}
    moments::Moments{T}
    errors::Union{Nothing,Matrix{T}}
    observation::Union{Observation,EnsembleObservation}
    evaluation_points
    settings::MomentSettings
end
#TODO: Add types
#NOTE: Make τ vector a field?

"Ensemble moments structure"
struct EnsembleMoments{T<:AbstractFloat}
    M1::Vector{Matrix{T}}
    M2::Vector{Matrix{T}}
end

function MomentSolution(observation,settings::MomentSettings)

    moments,errors = build_moments(observation, settings)
    return MomentSolution(moments,
                           errors,
                           observation,
                           center(settings.bin_edges),
                           settings)
end

function make_grid(tau_vector::AbstractVector,edge_vector::LinRange)
    return broadcast((x,y)->(x,y),tau_vector,(1:edge_vector.lendiv)')
end

center(x::LinRange) = (x[1:end-1]+x[2:end])/2

"Calculating moments with histograms"
function build_moments(observation::Observation, settings::MomentSettings)
    moments, errors = moments_map(observation.X,
                                   settings.time_shift_sample_points,
                                   settings.bin_edges,
                                   settings.ti_grid)
    errors = nothing
    return moments, errors
end

"Calculating ensemble moments with histograms"
function build_moments(observation::EnsembleObservation, settings::MomentSettings)
    ensembleMoments = moments_map(observation.X,
                                 settings.time_shift_sample_points,
                                 settings.bin_edges,
                                 settings.ti_grid)

    errors = nothing

    M1mean = mean(ensembleMoments.M1)
    M2mean = mean(ensembleMoments.M2)

    return Moments(M1mean, M2mean), errors
end

# BUG: When bins have no entries they give NaN
function get_moments(X, iX, tau)
    inc = X[iX .+ tau] .- X[iX]
    M1 = mean(inc)
    residuals = inc .- M1
    M2 = mean(residuals.^2)
    #KSerror = KS(residuals/(M2*sqrt(2)))
    KSerror = nothing
    return M1, M2, KSerror
end
function KS(Y::AbstractArray{T}) where T
    Ysort = sort(Y)
    D = zero(T)
    N = length(Y)
    for (i,v) in enumerate(Ysort)
        Dtmp = max(NCDF(v) - convert(T,(i-one(T))/N),
                   convert(T,i/N) - NCDF(v))
        D = max(D,Dtmp)
    end
    return D
end
function NCDF(x::T) where T<:Real
    return oftype(x,0.5)*(one(T)+erf(x))
end
function erf(x::T) where T<:Real
    if x < zero(T)
        return -erfpos(-x)
    else
        return erfpos(x)
    end
end
function erfpos(x::T) where T<:Real
    a1 = oftype(x,0.278393)
    a2 = oftype(x,0.230389)
    a3 = oftype(x,0.000972)
    a4 = oftype(x,0.078108)
    x1 = muladd(x,a4,a3)
    x2 = muladd(x,x1,a2)
    x3 = muladd(x,x2,a1)
    x4 = muladd(x,x3,one(T))
    x5 = x4*x4
    return one(T) - inv(x5*x5)
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
    M2 = broadcast(x->x[2],M1M2)
    errors = broadcast(last,M1M2)

    return Moments(M1, M2), errors
end
function moments_map(X::AbstractMatrix{T},tau_vector,edge_vector::LinRange,ti_grid) where T
    #HACK: Do I need this explicit type declaration?
    vecMoments::Vector{Moments{T}} = map(eachcol(X)) do y
        moments_map(y,tau_vector,edge_vector,ti_grid)[1]
    end
    l = length(vecMoments)

    return EnsembleMoments(map(x->vecMoments[x].M1,1:l),
                           map(x->vecMoments[x].M2,1:l))
end
