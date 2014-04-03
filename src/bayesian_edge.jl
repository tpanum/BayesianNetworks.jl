import Graphs: edge_index, source, target

type BayesianEdge
	index::Int
	source::BayesianNode
	target::BayesianNode

	BayesianEdge(s::BayesianNode, t::BayesianNode) = new(0,s,t)
end

BayesianEdge{T <: BayesianNode}(s::CBayesianNode, t::T) = throw("Source cannot be of type CBayesianNode")

edge_index(e::BayesianEdge) = e.index

source(e::BayesianEdge) = e.source
target(e::BayesianEdge) = e.target
