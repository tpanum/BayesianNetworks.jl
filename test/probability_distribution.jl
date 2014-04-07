pd1 = ProbabilityDistribution([0.5,0.5], ["head","tails"])

@test states(pd1) == ["head","tails"]
@test_approx_eq 0.5 pd1["head"]

pd2 = ProbabilityDistribution([0.5,0.5], ["tails","head"])

@test pd1 == pd2

pd3 = ProbabilityDistribution([0.6,0.4], ["tails","head"])

@test pd1 == pd2 == pd3

@test_approx_eq 0.6 pd3["tails"]

@test_throws pd3 = ProbabilityDistribution([0.7,0.4], ["tails","head"])

pd4 = ProbabilityDistribution([0.2, 0.1, 0.2, 0.2, 0.1, 0.2], ["one", "two", "three", "four", "five", "six"])

@test_approx_eq 0.2 pd4["one"]

@test_throws pd4 = ProbabilityDistribution([0.2, 0.2, 0.2, 0.2, 0.2, 0.2], ["one", "two", "three", "four", "five", "six"])
