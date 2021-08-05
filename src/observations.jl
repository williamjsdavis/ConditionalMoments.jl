"Structure for single observation"
struct Observation{S<:Real,T<:AbstractVector{S}} <: AbstractVector{S}
    X::T
    dt::S
    npoints
end

Observation(X,dt) = Observation(X,dt,length(X))

size(a::Observation) = (a.npoints,)

function getindex(x::Observation, i::Integer)
    checkbounds(x, i)
    return Base.getindex(x.X, i)
end
getindex(x::Observation, I::AbstractVector{Bool}) = x.X[findall(I)]
getindex(x::Observation, I::AbstractArray{Bool}) = x.X[LinearIndices(I)[findall(I)]]
getindex(x::Observation, ::Colon) = copy(x.X)

"Structure for ensemble observation"
struct EnsembleObservation{S<:Real,T<:AbstractMatrix{S}} <: AbstractMatrix{S}
    X::T
    dt::S
    npoints
    nsample
end

EnsembleObservation(X,dt) = EnsembleObservation(X,dt,size(X,1),size(X,2))

size(a::EnsembleObservation) = (a.npoints,a.nsample)

function getindex(x::EnsembleObservation, i::Integer)
    checkbounds(x, i)
    return Base.getindex(x.X, i)
end

function getindex(x::EnsembleObservation, i::Integer, j::Integer)
    checkbounds(x, i, j)
    return Base.getindex(x.X, i, j)
end
getindex(x::EnsembleObservation, ::Colon) = copy(x.X)
