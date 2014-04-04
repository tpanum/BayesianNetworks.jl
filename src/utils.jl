function normalize_factor{R <: Real}(arr::Array{R})
    arr ./ sum(arr)
end

function normpdf(mu, sigma)
    x -> (1/(sigma*sqrt(2*pi)))*e^((-(x-mu)^2)/(2*sigma^2))
end

function group_combinations(groups::Array{Array,1})
    elem_type=eltype(groups[1])
    res=Array(elem_type, prod(map(length, groups)), length(groups))
    for i=1:length(groups)
        g = groups[i]
        step=convert(Int, size(res,1)/length(g))
        if i%2 == 0
            for j=1:step
                range=(j-1)*length(g)+1:j*length(g)
                res[range,i]=g
            end
        else
            for j=1:length(g)
                range=(j-1)*length(g)+1:j*length(g)
                res[range,i]=fill(g[j],step)
            end
        end
    end
    sets=Array(Set{elem_type},size(res,1))
    sets[:] = [ Set(res[i,:]) for i=1:size(res,1) ]
end
