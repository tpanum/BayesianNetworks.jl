function normalize_factor{R <: Real}(arr::Array{R})
    arr ./ sum(arr)
end

function normpdf(mu, sigma)
    x -> (1/(sigma*sqrt(2*pi)))*e^((-(x-mu)^2)/(2*sigma^2))
end
