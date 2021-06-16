"Structure for single observation"
struct Observation
    X
    dt
    npoints
    Observation(X,dt) = new(X,dt,length(X))
end

#TODO: Add multiple observation data structure
