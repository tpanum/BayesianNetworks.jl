type BayesianEdge
	index::Int
	source::BayesianNode
	target::BayesianNode

	BayesianEdge(s::BayesianNode, t::BayesianNode) = new(0,s,t)
end

edge_index(e::BayesianEdge) = e.index
