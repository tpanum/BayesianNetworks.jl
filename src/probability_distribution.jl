import Base.length

type ProbabilityDistribution{T <: Real,K}
    ps::Array{T}
    dim_states::(Array{K,1},Array{K,1})

    function check_pd_sum!{N <: Real}(_ps::Array{N})
        if sum(_ps) != 1
            throw("Probability Distributions must sum to 1")
        else
            true
        end
    end
    
    function ProbabilityDistribution(_ps::Array{T,1}, _ss::Array{K,1})

        check_pd_sum!(_ps)
        order=sortperm(_ss)
        new(_ps[order], (_ss[order],))
    end
    function ProbabilityDistribution(_ps::Array{T,2}, _ss::Array{Array{K,1},1})
        check_pd_sum!(_ps)

        if length(_ss) != 2
            throw("Dimension mismatch")
        end
        
        order_dim_1=sortperm(_ss[1])
        order_dim_2=sortperm(_ss[2])
        new(_ps[order_dim_1,order_dim_2], (_ss[1][order_dim_1],_ss[2][order_dim_1]))
    end
end

ProbabilityDistribution{T,K}(ps::Array{T,1}, ss::Array{K,1}) = ProbabilityDistribution{T,K}(ps, ss)
ProbabilityDistribution{T,K}(ps::Array{T,2}, ss::Array{Array{K,1},1}) = ProbabilityDistribution{T,K}(ps, ss)

states(pd::ProbabilityDistribution) = pd.dim_states
states(pd::ProbabilityDistribution,i::Integer) = states(pd)[i]

function probabilities(pd::ProbabilityDistribution)
    pd.ps
end

function length(pd::ProbabilityDistribution)
    length(pd.ps)
end

function getindex{T,K}(pd::ProbabilityDistribution{T,K}, key::K)
    if !(key in states(pd)[1])
        throw("Invalid key")
    end
    pd.ps[key .== states(pd)[1]]
end

function getindex{T,K}(pd::ProbabilityDistribution{T,K}, key1::K, key2::K)
    if !(key1 in states(pd)[1])
        throw("Invalid key")
    end

    if !(key2 in states(pd)[2])
        throw("Invalid key")
    end
    
    pd.ps[key1 .== states(pd)[1], key2 .== states(pd)[2]][1]
end

function ==(pd1::ProbabilityDistribution, pd2::ProbabilityDistribution)
    length(setdiff(Set(states(pd1)),Set(states(pd2)))) == 0
end

function lpd{K}(states::K)
    m = length(states)
    pb = Array(Float64, m)
    fill!(pb, 1/m)
    ProbabilityDistribution(pb, states)
end
