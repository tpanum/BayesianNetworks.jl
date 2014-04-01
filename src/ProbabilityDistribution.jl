type ProbabilityDistribution{T <: FloatingPoint, K}
    ps::Array{T,1}
    states::Array{K,1}

    function ProbabilityDistribution(_ps::Array{T,1}, _ss::Array{K,1})
        if sum(_ps) != 1
            throw("Probability Distributions must sum to 1")
        end
        new(_ps, _ss)
    end
end

ProbabilityDistribution{T,K}(ps::Array{T,1}, ss::Array{K,1}) = ProbabilityDistribution{T,K}(ps, ss)

function states(pd::ProbabilityDistribution)
    pd.states
end