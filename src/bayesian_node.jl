abstract BayesianNode

type DBayesianNode <: BayesianNode
    index::Int
    label::Symbol
    pd::ProbabilityDistribution

    function DBayesianNode(_label::Symbol, _pd::ProbabilityDistribution)
        new(0, _label, _pd)
    end
end

function ==(n1::DBayesianNode, n2::DBayesianNode)
    n1.index == n2.index && n1.label == n2.label && n1.pd == n2.pd
end

type CBayesianNode <: BayesianNode
    index::Int
    label::Symbol
    pdf::Function

    CBayesianNode(l::Symbol, d::Distribution) = new(0, l,x->pdf(d,x))
end

function probability(n::CBayesianNode, x)
    n.pdf(x)
end

node_index(n::DBayesianNode) = n.index
node_index(n::CBayesianNode) = n.index
