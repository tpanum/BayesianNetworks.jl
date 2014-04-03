function normalize_factor{R <: Real}(arr::Array{R})
    arr ./ sum(arr)
end
