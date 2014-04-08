import Base.length

abstract PDistribution

check_pd_sum!{N <: Real}(_ps::Array{N,1}) = sum(_ps) != 1 ? throw("Probability Distributions must sum to 1") : true;
check_pd_sum!{N <: Real}(_ps::Array{N,2}) = sum(_ps) != size(_ps,1) ? throw("Conditional Probability Distributions must consist of probability distributions which sum to 1") : true;

type ProbabilityDistributionVector{T <: Real, K} <: PDistribution
    states::Array{K,1}
    ps::Array{T,1}

    function ProbabilityDistributionVector(_states::Array{K,1}, _ps::Array{T,1})
        check_pd_sum!(_ps)
        new(_states, _ps)
    end
end

type ProbabilityDistributionMatrix{T <: Real, K, Q} <: PDistribution
    states::Array{K,1}
    ps::Array{T,2}
    conditionals::Array{Q,1}

    function ProbabilityDistributionMatrix(_states::Array{K,1}, _ps::Array{T,2}, _conditionals::Array{Q,1})
        check_pd_sum!(_ps)
        new(_states, _ps, _conditionals)
    end
end

states(pd::PDistribution) = pd.states
conditionals(pd::PDistribution) = pd.conditionals

function ==(pd1::PDistribution, pd2::PDistribution)
    length(setdiff(Set(states(pd1)),Set(states(pd2)))) == 0
end

ProbabilityDistribution{T,K}(states::Array{K,1}, ps::Array{T,1}) = ProbabilityDistributionVector{T,K}(states, ps)
ProbabilityDistribution{T,K,Q}(states::Array{K,1}, ps::Array{T,2}, conditionals::Array{Q,1}) = ProbabilityDistributionMatrix{T,K,Q}(states, ps, conditionals)

function probabilities(pd::PDistribution)
    pd.ps
end

function length(pd::PDistribution)
    length(pd.ps)
end

function getindex{K}(pd::PDistribution, key::K)
    states(pd)::Array{K,1}
    
    if !(key in states(pd))
        throw("Invalid key")
    end

    if typeof(pd) <: ProbabilityDistributionVector
        pd.ps[key .== states(pd)]
    else
        # is matrix
        pd.ps[:,key .== states(pd)]
    end

end

## Later...

## function getindex{T,K}(pd::ProbabilityDistribution{T,K}, key1::K, key2::K)
##     if !(key1 in states(pd)[1])
##         throw("Invalid key")
##     end

##     if !(key2 in states(pd)[2])
##         throw("Invalid key")
##     end

##     pd.ps[key1 .== states(pd)[1], key2 .== states(pd)[2]][1]
## end

function lpd{K}(states::K)
    m = length(states)
    pb = Array(Float64, m)
    fill!(pb, 1/m)
    ProbabilityDistribution(pb, states)
end

function joint_probability_distributions(p1::PDistribution, p2::PDistribution)
    collect([p1.ps[i]*p2.ps[j] for i=1:length(p1.ps), j=1:length(p2.ps)])
end
