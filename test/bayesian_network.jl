n1 = BayesianNetwork([], [])
n1 = BayesianNetwork()
pd1 = ProbabilityDistribution([0.5,0.5], ["head","tails"])
pd2 = ProbabilityDistribution([0.3,0.7], ["head","tails"])
a1 = DBayesianNode(:hulu, pd1)
a2 = DBayesianNode(:bulu, pd2)

@test a1.label == :hulu

@test length(n1.binclist) == 0
@test length(n1.finclist) == 0

add_node!(n1, a1)

@test length(n1.binclist) == 1
@test length(n1.finclist) == 1

add_node!(n1, a2)

@test length(n1.binclist) == 2
@test length(n1.finclist) == 2

@test a1.index == 1
@test a2.index == 2
@test length(n1.nodes) == 2

e1 = add_edge!(n1, a1, a2)

@test source(e1).label == :hulu
@test edge_index(e1) == 1
@test length(n1.edges) == 1
@test n1.edges[1] == e1
@test length(in_neighbors(a2,n1)) == 1
@test length(out_neighbors(a2,n1)) == 0
@test length(out_neighbors(a1,n1)) == 1
@test out_neighbors(a1,n1)[1].label == :bulu
@test in_degree(a2,n1) != out_degree(a2,n1)

pd3 = ProbabilityDistribution([0.25,0.75], ["head","tails"])
pd4 = ProbabilityDistribution([0.75,0.25], ["head","tails"])
b1 = DBayesianNode(:bjarke, pd3)
b2 = DBayesianNode(:hesthaven, pd4)
b3 = CBayesianNode(:esben, x->x^0.5)

n2 = BayesianNetwork([b1,b2,b3],[])

@test b1.index == 1

pd5 = ProbabilityDistribution([0.46,0.54], ["head","tails"])
pd6 = ProbabilityDistribution([0.99,0.01], ["head","tails"])
c1 = DBayesianNode(:thomas, pd5)
c2 = DBayesianNode(:panum, pd6)
c3 = CBayesianNode(:moller, x->x^0.5)

@test_throws CBayesianNode(:moller, x-> "I'm not entirely sure what I'm doing")

n3 = BayesianNetwork([c1,c2],[])

add_node!(n3, c3)

@test length(nodes(n3)) == 3

@test_throws add_node!(n3,b1)
@test node_index(b1) == 1

@test_throws add_edge!(n3,b1,b2)
@test_throws add_edge!(n3,c3,c1)
