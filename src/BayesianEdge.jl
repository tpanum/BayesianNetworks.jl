import Graphs: edge_index, source, target

type BayesianEdge
	index::Int
	source::BayesianNode
	target::BayesianNode

	BayesianEdge(s::BayesianNode, t::BayesianNode) = new(0,s,t)
end

edge_index(e::BayesianEdge) = e.index

source(e::BayesianEdge) = e.source
target(e::BayesianEdge) = e.target
