@test_throws DBayesianNode(1, :hulu, ProbabilityDistribution([0.5,0.5], ["head","tails"]))
@test_throws DBayesianNode("Hej", ProbabilityDistribution([0.5,0.5], ["head","tails"]))
@test_throws DBayesianNode(:hulu, x -> x^5)

pd1 = ProbabilityDistribution([0.5,0.5], ["head","tails"])
pd2 = ProbabilityDistribution([0.3,0.7], ["head","tails"])
a1 = DBayesianNode(:hulu, pd1)
	a2 = DBayesianNode(:bulu, pd2)
a3 = DBayesianNode(:hulu, ProbabilityDistribution([0.5,0.5], ["tails", "head"]))

@test a1 == a1
@test a1 == a3

a1.index = 2
a3.index = 4

@test a1 == a1
@test a1 != a3

@test_throws CBayesianNode(1, :hulu, x -> x^5)
@test_throws CBayesianNode(:hulu, pd1)
b1 = CBayesianNode(:hulu, x -> x^5)

@test b1.label == :hulu
@test_throws CBayesianNode(:hulu, x -> "$x^5")
@test_throws CBayesianNode(:hulu, x -> :hej)

b2 = CBayesianNode(:bjarke, x -> x)
b3 = CBayesianNode(:bjarke, x -> x)

@test b2.label == :bjarke

@test b2 == b2
@test b2 == b3

b2.index = 2
b3.index = 3

@test b2 == b2
@test b2 != b3

@test probability(b3, 1) == b3.pdf(1)
@test probability(b3, 2) != probability(b3, 4)
