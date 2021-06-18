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

#TODO: Add multiple observation data structure
