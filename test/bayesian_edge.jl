pd1 = ProbabilityDistribution([0.5,0.5], ["head","tails"])
pd2 = ProbabilityDistribution([0.3,0.7], ["head","tails"])

a1 = DBayesianNode(:hulu, pd1)
a2 = DBayesianNode(:bulu, pd2)
b3 = CBayesianNode(:esben, x->x^0.5)

e1 = BayesianEdge(a1,a2)
e2 = BayesianEdge(a1,b3)

@test edge_index(e1) == 0
@test edge_index(e2) == 0
@test source(e1) == a1
@test target(e1) == a2
@test target(e2) == b3
@test_throws e2 = BayesianEdge(b3,a1)

k1 = DBayesianNode(:bjarke, pd1)
k2 = DBayesianNode(:thomas, pd2)
k3 = DBayesianNode(:esben, pd1)

h1 = BayesianEdge(k1,k2)
h2 = BayesianEdge(k1,k2)
h3 = BayesianEdge(k2,k1)
h4 = BayesianEdge(k1,k3)

@test h1 == h1
@test h1 == h2
@test h1 != h3
@test h3 != h4
@test h1 != h4

h1.index = 4
h2.index = 3
h3.index = 2
h4.index = 1

@test h1 == h1
@test h1 != h2
@test h1 != h3
@test h3 != h4
@test h1 != h4
