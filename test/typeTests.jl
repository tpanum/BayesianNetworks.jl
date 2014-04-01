b = BayesianNetwork(Array(BayesianNode,0), Array(ExEdge{BayesianNode},0))
a1 = BayesianNode(1,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2]))
a2 = BayesianNode(2,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2]))

add_node!(b,a1)
add_node!(b,a2)
#add_edge!(b,a1,a2)

#@test num_edges(b) == 1
@test num_nodes(b) == 2
#@test length(b.nodes[node_index(a2)].ingoingEdges) == 1