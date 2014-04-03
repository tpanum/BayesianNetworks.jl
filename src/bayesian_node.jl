abstract BayesianNode

type DBayesianNode <: BayesianNode
    index::Int
    label::Symbol
    pb::ProbabilityDistribution

    DBayesianNode(_label::Symbol, _pb::ProbabilityDistribution) = new(0, _label, _pb)
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

function probability(n::CBayesianNode, x)
    n.pdf(x)
end

node_index(n::DBayesianNode) = n.index
node_index(n::CBayesianNode) = n.index
