function normalize_factor{R <: Real}(arr::Array{R})
    arr ./ sum(arr)
end

function normpdf(mu, sigma)
    x -> (1/(sigma*sqrt(2*pi)))*e^((-(x-mu)^2)/(2*sigma^2))
end

function group_combinations(groups::Array{Array,1})
    if length(groups) > 0
        elem_type=eltype(groups[1])
        combinations=prod(map(length, groups))
        res=Array(elem_type, combinations, length(groups))

        groups=groups[sortperm(map(length, groups))]
        
        prev_group_elem_size=combinations
        
        for i=1:length(groups)

            g=groups[i]
            prev_steps=convert(Int,combinations/prev_group_elem_size)
            group_elem_size=convert(Int,prev_group_elem_size/length(g))

            step_elems=reduce(vcat,map(x -> fill(x,group_elem_size), g))
            steps=reduce(vcat,fill(step_elems,prev_steps))

            res[:,i]=steps
            prev_group_elem_size=group_elem_size
        end
        
        sets=Array(Set{elem_type},combinations)
        sets[:] = [ Set(res[i,:]) for i=1:combinations ]
    else
        []
    end
end
