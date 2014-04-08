pd1 = ProbabilityDistribution(["head","tails"], [0.5,0.5])

@test states(pd1) == (["head","tails"])
@test_approx_eq 0.5 pd1["head"]

upd1 = ProbabilityDistribution(["test", "bøh", "bjarke", "thomas"])
@test Set(states(upd1)) == Set(["bjarke", "bøh", "test", "thomas"])

upd2 = ProbabilityDistribution(["test", "bøh", "bjarke", "thomas"])

@test upd1 == upd2

upd3 = ProbabilityDistribution(["test", "bøh", "bjarke", "esben"])

@test upd1 != upd3

pd2 = ProbabilityDistribution(["tails","head"], [0.5,0.5])

@test pd1 == pd2

pd3 = ProbabilityDistribution(["tails","head"], [0.6,0.4])

@test pd1 == pd2 == pd3

@test_approx_eq 0.6 pd3["tails"]

@test_throws pd3 = ProbabilityDistribution(["tails","head"], [0.7,0.4])

pd4 = ProbabilityDistribution(["one", "two", "three", "four", "five", "six"], [0.2, 0.1, 0.2, 0.2, 0.1, 0.2])

@test_approx_eq 0.2 pd4["one"]

@test_throws pd4 = ProbabilityDistribution(["one", "two", "three", "four", "five", "six"], [0.2, 0.2, 0.2, 0.2, 0.2, 0.2])
