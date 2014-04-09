import Base.length

abstract PDistribution

check_pd_sum!{N <: Real}(_ps::Array{N,1}) = sum(_ps) != 1 ? throw("Probability Distributions must sum to 1") : true;
check_pd_sum!{N <: Real}(_ps::Array{N,2}) = sum(_ps) != size(_ps,1) ? throw("Conditional Probability Distributions must consist of probability distributions which sum to 1") : true;
check_unique!(s1) = !(length(s1) == length(unique(s1))) ? throw("States must be unique") : true;

type ProbabilityDistributionVector{T <: Real, K} <: PDistribution
    states::Array{K,1}
    ps::Array{T,1}

    function ProbabilityDistributionVector(_states::Array{K,1}, _ps::Array{T,1})
        check_unique!(_states)
        length(_ps) > 0 ? check_pd_sum!(_ps) : nothing;
        new(_states, _ps)
    end
end

type ProbabilityDistributionMatrix{T <: Real, K, Q} <: PDistribution
    states::Array{K,1}
    ps::Array{T,2}
    conditionals::Array{Q,1}

    function ProbabilityDistributionMatrix(_states::Array{K,1}, _ps::Array{T,2}, _conditionals::Array{Q,1})
        check_unique!(_states)
        check_pd_sum!(_ps)
        new(_states, _ps, _conditionals)
    end
end

states(pd::PDistribution) = pd.states
conditionals(pd::ProbabilityDistributionMatrix) = pd.conditionals

unsorted_equality(arr1::Array, arr2::Array) = length(setdiff(Set(arr1),Set(arr2))) == 0

==(pd1::PDistribution, pd2::PDistribution) = unsorted_equality(states(pd1),states(pd2))

ProbabilityDistribution{T,K}(states::Array{K,1}, ps::Array{T,1}) = ProbabilityDistributionVector{T,K}(states, ps)
ProbabilityDistribution{T,K,Q}(states::Array{K,1}, ps::Array{T,2}, conditionals::Array{Q,1}) = ProbabilityDistributionMatrix{T,K,Q}(states, ps, conditionals)
ProbabilityDistribution{K}(states::Array{K,1}) = ProbabilityDistribution(states, Real[])

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

function unique_states(p1::PDistribution, p2::PDistribution)
    length(setdiff(Set(states(p1)), Set(states(p2)))) == length(states(p1))
end

function *(p1::ProbabilityDistributionVector, p2::ProbabilityDistributionVector)
    if !unique_states(p1,p2)
        throw("State conflict")
    end

    ps_m=probabilities(p1)'.*probabilities(p2)
    s_p1=states(p1)
    s_p2=states(p2)

    combinations=length(s_p1)*length(s_p2)
    # indexes of values to in the ps_m
    ## indencies=find(triu(ones(Bool, size(ps_m,1), size(ps_m,2))))

    common_type=promote_type(eltype(s_p1), eltype(s_p2))
    j_states=Array(Set{common_type}, combinations)

    size_ps_m=size(ps_m)

    for i=1:combinations
        p1_s_index, p2_s_index = single_to_multi_index(i, size_ps_m)
        j_states[i]=Set{common_type}({s_p1[p1_s_index], s_p2[p2_s_index]})
    end

    ProbabilityDistribution(j_states, reshape(ps_m, combinations))
end

function join_sets{K}(x::Set{K}, y)
    c_type=promote_type(K,typeof(y))
    Set{c_type}(c_type[collect(x),y])
end

function join_sets(x, y)
    c_type=promote_type(typeof(x),typeof(y))
    Set{c_type}(c_type[x,y])
end

function zip_sets(arr1::Array, arr2::Array)
    if length(arr1) != length(arr2)
        throw("Length of given arrays must be the same.")
    end
    [ join_sets(arr1[i], arr2[i]) for i=1:length(arr1) ]
end

function *(p1::ProbabilityDistributionMatrix, p2::ProbabilityDistributionVector)
    c_p1 = conditionals(p1)
    s_p2 = states(p2)

    !unsorted_equality(c_p1, s_p2) ? throw("State mismatch") : nothing;

    p1_order=sortperm(c_p1)
    p2_order=sortperm(s_p2)

    sorted_ps_m=probabilities(p1)[p1_order,:] .* probabilities(p2)[p2_order]
    sorted_ps=reshape(sorted_ps_m[p1_order,:], length(sorted_ps_m))

    l_p2_elems = reduce(vcat, map(x -> fill(x, length(c_p1)), states(p1)))
    l_p1_sets = reduce(vcat, map(x -> c_p1, [1:length(states(p1))]))

    ProbabilityDistribution(zip_sets(l_p1_sets, l_p2_elems), sorted_ps)
end
