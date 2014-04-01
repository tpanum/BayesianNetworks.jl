b1 = BayesianNetwork(Array(BayesianNode,0), Array(ExEdge{BayesianNode},0))
a1 = BayesianNode(1,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2]))
a2 = BayesianNode(2,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2]))

a3 = BayesianNode(1,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2]))
a4 = BayesianNode(2,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2]))
e1 = BayesianEdge(1,a3,a4)

a5 = BayesianNode(1,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2]))
a6 = BayesianNode(2,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2]))
e2 = BayesianEdge(1,a5,a6)

@test a3.index == 1
@test a4.index == 2
@test e1.target.index == 2

c = BayesianNetwork([a4,a3], [e1])
d = BayesianNetwork([a5,a6], [e2])

@test a5.index == 1
@test a6.index == 2
@test e2.target.index == 2


add_node!(b1,a1)
add_node!(b1,a2)
add_edge!(b1,a1,a2)

@test num_edges(b1) == 1
@test num_nodes(b1) == 2
@test length(b1.nodes[node_index(a2)].ingoingEdges) == 1
@test a3.index == 2
@test a4.index == 1
@test e1.target.index == 1
