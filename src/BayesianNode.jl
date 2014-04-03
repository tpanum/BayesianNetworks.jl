abstract BayesianNode

type DBayesianNode <: BayesianNode
    index::Int
    label::Symbol
    pb::ProbabilityDistribution

    function BayesianNode(_label::Symbol, _pb::ProbabilityDistribution)
        new(0, _label, _pb)
    end
end

type CBayesianNode <: BayesianNode
    index::Int
    label::Symbol
    pdf::Function

    CBayesianNode(l::ASCIIString, d::Distribution) = new(0, l,x->pdf(d,x))
end

function probability(n::CBayesianNode, x)
    n.pdf(x)
end

node_index(n::DBayesianNode) = n.index
node_index(n::CBayesianNode) = n.index
