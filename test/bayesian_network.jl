n1 = BayesianNetwork([], [])
n1 = BayesianNetwork()
pd1 = ProbabilityDistribution(["head","tails"],[0.5,0.5])
pd2 = ProbabilityDistribution(["head","tails"],[0.3,0.7])
a1 = DBayesianNode(:hulu, pd1)
a2 = DBayesianNode(:bulu, pd2)

@test a1.label == :hulu

@test length(n1.binclist) == 0
@test length(n1.finclist) == 0

ie1 = in_edges(a1, n1)
@test length(ie1) == 0

@test in_degree(a1, n1) == 0

oe1 = out_edges(a1, n1)
@test length(oe1) == 0

@test out_degree(a1, n1) == 0

add_node!(n1, a1)

@test cached_result(n1,P(:hulu)) == pd1
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

@test symbols_in_network(n1, [:hulu, :bulu]) == true
@test symbols_in_network(n1, [:hulu, :bjarke]) == false

@test add_probability!(n1, P(:hulu|:bulu), ProbabilityDensityDistribution(states(a1), [x -> x+1, x -> x+2])) == true
@test add_probability!(n1, P(:hulu|:bjarke), ProbabilityDensityDistribution(states(a1), [x -> x+1, x -> x+2])) == false
@test add_probability!(n1, P(:bjarke|:hulu), ProbabilityDensityDistribution(states(a1), [x -> x+1, x -> x+2])) == false

pd3 = ProbabilityDistribution(["head","tails"],[0.25,0.75])
pd4 = ProbabilityDistribution(["head","tails"],[0.75,0.25])
b1 = DBayesianNode(:bjarke, pd3)
b2 = DBayesianNode(:hesthaven, pd4)
b3 = CBayesianNode(:esben, x->x^0.5)

n2 = BayesianNetwork([b1,b2,b3],[])

@test b1.index == 1

pd5 = ProbabilityDistribution(["head","tails"],[0.46,0.54])
pd6 = ProbabilityDistribution(["head","tails"],[0.99,0.01])
c1 = DBayesianNode(:thomas, pd5)
c2 = DBayesianNode(:panum, pd6)
c3 = CBayesianNode(:moller, x->x^0.5)

@test_approx_eq_eps probability(c3,5) 2.236 0.0001

@test_throws CBayesianNode(:moller, x-> "I'm not entirely sure what I'm doing")

n3 = BayesianNetwork([c1,c2],[])

add_node!(n3, c3)
@test_throws add_edge!(n3,c3,c2)

e1 = add_edge!(n3,c2,c3)
@test typeof(e1) == BayesianEdge
@test length(edges(n3)) == 1
@test source(e1) == c2

@test length(nodes(n3)) == 3

@test_throws add_node!(n3,b1)
@test node_index(b1) == 1

###################################
#Tests that should cause errors
###################################
@test_throws add_edge!(n3,b1,b2)
@test_throws add_edge!(n3,c3,c1)
@test_throws q1 = DBayesianNode("hej", pd3)
@test_throws q1 = CBayesianNode("Hej", x -> 1)

###################################

pd7 = ProbabilityDistribution(["head","tails"],[0.46,0.54])
pd8 = ProbabilityDistribution(["head","tails"],[0.99,0.01])
pd9 = ProbabilityDistribution(["head","tails"],[0.99,0.01])
pd10 = ProbabilityDistribution(["head","tails"],[0.99,0.01])
pd11 = ProbabilityDistribution(["head","tails"],[0.99,0.01])
pd12 = ProbabilityDistribution(["head","tails"],[0.99,0.01])
pd13 = ProbabilityDistribution(["head","tails"],[0.99,0.01])
pd14 = ProbabilityDistribution(["head","tails"],[0.99,0.01])
d1 = DBayesianNode(:d1, pd7)
d2 = DBayesianNode(:d2, pd8)
d3 = DBayesianNode(:d3, pd9)
d4 = DBayesianNode(:d4, pd10)
d5 = DBayesianNode(:d5, pd11)
d6 = DBayesianNode(:d6, pd12)
d7 = DBayesianNode(:d7, pd13)
d8 = DBayesianNode(:d8, pd14)
n4 = BayesianNetwork([d1,d2,d3,d4,d5,d6,d7,d8],[])

add_edge!(n4,d2,d1)
add_edge!(n4,d3,d1)
add_edge!(n4,d6,d7)
add_edge!(n4,d7,d2)
add_edge!(n4,d8,d5)
add_edge!(n4,d1,d5)

@test legal_configuration(n4, CPD([:d1], [:d2,:d3])) == true
@test legal_configuration(n4, CPD([:d2,:d3], [:d1])) == true
@test legal_configuration(n4, CPD([:d1], [:d2,:d3,:d5,:d6,:d7,:d8])) == true
@test legal_configuration(n4, CPD([:d1], [:d2,:d3,:d8])) == true
@test legal_configuration(n4, CPD([:d2,:d3], [:d4])) == false
@test legal_configuration(n4, CPD([:d2], [:d4, :d1])) == false

@test cached_result(n4, P(:d1|:d2)) != false
@test cached_result(n4, P(:d4|:d2)) == false

####################################

pdbhs1 = ProbabilityDistribution(["head", "tails"], [0.5,0.5])
pdbhs2 = ProbabilityDistribution(["head", "tails"], [0.75,0.25])
abhs1 = DBayesianNode(:R, pdbhs1)
abhs2 = DBayesianNode(:S, pdbhs2)

nbhs1 = BayesianNetwork([abhs1, abhs2])
add_edge!(nbhs1, abhs1, abhs2)

@test check_requirements(nbhs1, P(:S|:R)) == false
add_probability!(nbhs1, P(:R|:S), ProbabilityDistribution(["head", "tails"], [0.33, 0.67]))
@test check_requirements(nbhs1, P(:S|:R)) == true
