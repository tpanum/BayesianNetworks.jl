n1 = BayesianNetwork([], [])
n1 = BayesianNetwork()
pd1 = ProbabilityDistribution([0.5,0.5], ["head","tails"])
pd2 = ProbabilityDistribution([0.3,0.7], ["head","tails"])
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

@test add_probability!(n1, P(:hulu|:bulu), ProbabilityDensityDistribution(states(a1,1), [x -> x+1, x -> x+2])) == true
@test add_probability!(n1, P(:hulu|:bjarke), ProbabilityDensityDistribution(states(a1,1), [x -> x+1, x -> x+2])) == false
@test add_probability!(n1, P(:bjarke|:hulu), ProbabilityDensityDistribution(states(a1,1), [x -> x+1, x -> x+2])) == false

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

pd7 = ProbabilityDistribution([0.46,0.54], ["head","tails"])
pd8 = ProbabilityDistribution([0.99,0.01], ["head","tails"])
pd9 = ProbabilityDistribution([0.99,0.01], ["head","tails"])
pd10 = ProbabilityDistribution([0.99,0.01], ["head","tails"])
d1 = DBayesianNode(:esben, pd7)
d2 = DBayesianNode(:pilgaard, pd8)
d3 = DBayesianNode(:moller, pd9)
d4 = DBayesianNode(:retard_node, pd10)
n4 = BayesianNetwork([d1,d2,d3, d4],[])

add_edge!(n4,d2,d1)
add_edge!(n4,d3,d1)
@test legal_configuration(n4, CPD([:esben], [:pilgaard,:moller])) == true
@test legal_configuration(n4, CPD([:pilgaard,:moller], [:esben])) == true
@test legal_configuration(n4, CPD([:pilgaard,:moller], [:retard_node])) == false
@test legal_configuration(n4, CPD([:pilgaard], [:retard_node, :esben])) == false

####################################

pdbhs1 = ProbabilityDistribution([0.5,0.5], ["head", "tails"])
pdbhs2 = ProbabilityDistribution([0.75,0.25], ["head", "tails"])
abhs1 = DBayesianNode(:R, pdbhs1)
abhs2 = DBayesianNode(:S, pdbhs2)

nbhs1 = BayesianNetwork([abhs1, abhs2])
add_edge!(nbhs1, abhs1, abhs2)

@test check_requirements(nbhs1, P(:S|:R)) == false
# add_probability!(nbhs1, P(:R|:S), ProbabilityDistribution([0.33, 0.67], ["head", "tails"]))
# @test check_requirements(nbhs1, P(:S|:R)) == true
