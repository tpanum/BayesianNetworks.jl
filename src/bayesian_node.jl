abstract BayesianNode

type DBayesianNode <: BayesianNode
    index::Int
    label::Symbol
    pd::ProbabilityDistribution

    DBayesianNode(_label::Symbol, _pd::ProbabilityDistribution) = new(0, _label, set_state_names(_pd,_label))
end

function ==(n1::DBayesianNode, n2::DBayesianNode)
    n1.index == n2.index && n1.label == n2.label && n1.pd == n2.pd
end

type CBayesianNode <: BayesianNode
    index::Int
    label::Symbol
    pdf::Function

    function CBayesianNode(_label::Symbol, _f::Function)
        if !verify_real_to_real(_f)
            throw("Probability Density Function must be of type (input) Real -> (output) Real")
        end
        new(0, _label, _f)
    end
end

function verify_real_to_real(f::Function)
    try
        typeof(f(0)) <: Real
    catch
        false
    end
end

function ==(n1::CBayesianNode, n2::CBayesianNode)
    n1.index == n2.index && n1.label == n2.label && n1.pdf(1) == n2.pdf(1)
end

function probability(n::CBayesianNode, x)
    n.pdf(x)
end

function states(bn::DBayesianNode)
    states(bn.pd)
end

function Base.in(x,bn::DBayesianNode)
    if !(x in states(bn))
        throw("State mismatch, $x is not a part of the state space")
    end
    (x,bn)
end

function has_pd(bn::DBayesianNode)
    bn.pd != nothing
end

function has_pd(bn::CBayesianNode)
    false
end

function set_state_names(pd::ProbabilityDistribution, name::Symbol)
    for i=1:length(states(pd,1))
        pd.dim_states[1][i] = string(name,"{",states(pd,1)[i],"}")
    end
    pd
end

node_index{V <: BayesianNode}(n::V) = n.index
