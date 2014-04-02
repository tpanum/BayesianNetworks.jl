n1 = BayesianNetwork([], [])
n1 = BayesianNetwork()
pd1 = ProbabilityDistribution([0.5,0.5], ["head","tails"])
a1 = BayesianNode(:hulu, pd1)
a2 = BayesianNode(:bulu, pd1)

@test a1.label == :hulu

add_node!(n1, a1)
add_node!(n1, a2)

@test a1.index == 1
@test a2.index == 2
@test length(n1.nodes) == 2
