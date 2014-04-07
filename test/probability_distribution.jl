pd1 = ProbabilityDistribution([0.5,0.5], ["head","tails"])

@test states(pd1) == (["head","tails"],)
@test_approx_eq 0.5 pd1["head"]

pd2 = ProbabilityDistribution([0.5,0.5], ["tails","head"])

@test pd1 == pd2

pd3 = ProbabilityDistribution([0.6,0.4], ["tails","head"])

@test_approx_eq 0.6 pd3["tails"]

@test_throws pd3 = ProbabilityDistribution([0.7,0.4], ["tails","head"])


# 2-dimensional

pd2_1 = ProbabilityDistribution([0.4 0.1; 0.25 0.25], Array{ASCIIString,1}[["tails","head"],["happy","sad"]])

#@test pd2_1["tails","happy"] == 0.4

