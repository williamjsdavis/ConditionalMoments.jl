"Structure for single observation"
struct Observation{S,T<:AbstractVector{S}} <: AbstractVector{S}
    X::T
    dt::S
    npoints
end

Observation(X,dt) = Observation(X,dt,length(X))

#TODO: Add multiple observation data structure
