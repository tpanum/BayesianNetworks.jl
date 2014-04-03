b1 = BayesianNetwork()
a1 = DBayesianNode(1,"name", ProbabilityDistribution([0.5,0.5],[1,2]))
a2 = DBayesianNode(2,"name", ProbabilityDistribution([0.5,0.5],[1,2]))

a3 = DBayesianNode(1,"name", ProbabilityDistribution([0.5,0.5],[1,2]))
a4 = DBayesianNode(2,"name", ProbabilityDistribution([0.5,0.5],[1,2]))
e1 = BayesianEdge(1,a3,a4)

a5 = DBayesianNode(1,"name", ProbabilityDistribution([0.5,0.5],[1,2]))
a6 = DBayesianNode(2,"name", ProbabilityDistribution([0.5,0.5],[1,2]))
a7 = CBayesianNode(3, "name", Normal(0,1))
e2 = BayesianEdge(2,a5,a6)

@test a3.index == 1
@test a4.index == 2
@test e1.target.index == 2

c = BayesianNetwork([a4,a3, a7], [e1])
d = BayesianNetwork([a5,a6, a7], [e2])

@test a5.index == 1
@test a6.index == 2
@test e2.target.index == 2
@test e2.index == 1


add_node!(b1,a1)
add_node!(b1,a2)
add_node!(b1,a7)
add_edge!(b1,a1,a2)
add_edge!(b1,a1,a7)

@test num_edges(b1) == 2
@test num_nodes(b1) == 3
@test length(in_neighbors(a2, b1)) == 1
@test a3.index == 2
@test a4.index == 1
@test e1.target.index == 1
@test in_neighbors(a2,b1)[1].index == 1
@test out_neighbors(a1,b1)[1].index == 2
@test_approx_eq pdf(Normal(0,1),1) a7.pdf(1)


