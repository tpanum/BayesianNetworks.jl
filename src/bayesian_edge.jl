import Graphs: edge_index, source, target

type BayesianEdge
    index::Int
    source::BayesianNode
    target::BayesianNode

    BayesianEdge(s::BayesianNode, t::BayesianNode) = new(0,s,t)
end

function ==(e1::BayesianEdge, e2::BayesianEdge)
    e1.index == e2.index && e1.source == e2.source && e1.target == e2.target
end

BayesianEdge{T <: BayesianNode}(s::CBayesianNode, t::T) = throw("Source cannot be of type CBayesianNode")

edge_index(e::BayesianEdge) = e.index

source(e::BayesianEdge) = e.source
target(e::BayesianEdge) = e.target
