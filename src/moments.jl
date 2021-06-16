"Moment calculation settings for histogram methods"
struct MomentHistogramSettings
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
