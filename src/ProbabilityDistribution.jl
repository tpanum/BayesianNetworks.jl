type ProbabilityDistribution{T <: FloatingPoint, K}
    ps::Array{T,1}
    states::Array{K,1}

    function ProbabilityDistribution(_ps::Array{T,1}, _ss::Array{K,1})
        if sum(_ps) != 1
            throw("Probability Distributions must sum to 1")
        end
        new(_ps, sort(_ss))
    end
end

ProbabilityDistribution{T,K}(ps::Array{T,1}, ss::Array{K,1}) = ProbabilityDistribution{T,K}(ps, ss)

function states(pd::ProbabilityDistribution)
    pd.states
end

function probabilities(pd::ProbabilityDistribution)
    pd.ps
end

function length(pd::ProbabilityDistribution)
    length(pd.ps)
end

function ==(pd1::ProbabilityDistribution, pd2::ProbabilityDistribution)
    length(setdiff(Set(states(pd1)),Set(states(pd2)))) == 0
end
