abstract type MomentSettings end

"Moment calculation settings for histogram methods"
struct MomentHistogramSettings <: MomentSettings
    time_shift_sample_points
    bin_edges
    n_time_points
    n_evaluation_points
    function MomentHistogramSettings(time_shift_sample_points,bin_edges)
        n_time_points = length(time_shift_sample_points)
        n_evaluation_points = length(bin_edges)
        return new(time_shift_sample_points,
                   bin_edges,
                   n_time_points,
                   n_evaluation_points)
    end
end

"Moments structure"
struct Moments
    M1
    M2
    observation::Observation
    evaluation_points
    settings::MomentSettings
    function Moments(observation,settings)
        M1 = zeros(3,3)
        M2 = zeros(3,3)
        evaluation_points = settings.bin_edges
        return new(M1,M1,observation,evaluation_points,settings)
    end
end
