import Base.length

type ProbabilityDistribution{T <: FloatingPoint}
    ps::Array{T,1}
    states::Array{ASCIIString,1}

    function ProbabilityDistribution(_ps::Array{T,1}, _ss::Array{ASCIIString,1})
        if sum(_ps) != 1
            throw("Probability Distributions must sum to 1")
        end
        order=sortperm(_ss)
        new(_ps[order], _ss[order])
    end
end

ProbabilityDistribution{T}(ps::Array{T,1}, ss::Array{ASCIIString,1}) = ProbabilityDistribution{T}(ps, ss)

function states(pd::ProbabilityDistribution)
    pd.states
end

function probabilities(pd::ProbabilityDistribution)
    pd.ps
end

function length(pd::ProbabilityDistribution)
    length(pd.ps)
end

function getindex{T,K}(pd::ProbabilityDistribution{T}, key::K)
    if !(key in pd.states)
        throw("Invalid key")
    end
    pd.ps[key .== pd.states]
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

