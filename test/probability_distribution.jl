pd1 = ProbabilityDistribution([0.5,0.5], ["head","tails"])

@test states(pd1) == ["head","tails"]

pd2 = ProbabilityDistribution([0.5,0.5], ["tails","head"])

@test pd1 == pd2
