pd1 = ProbabilityDistribution([0.5,0.5], ["head","tails"])
pd2 = ProbabilityDistribution([0.4,0.6], ["tails","head"])
cpt = CPT(["p|sun",:"p|rain"],[pd1,pd2])

@test cpt["p|sun"]==pd1
@test cpt[:"p|rain"]==pd2
@test_throws cpt = CPT(["p|sun"],[pd1,pd2])
@test_throws cpt = CPT(["p|sun",:"p|rain"],[pd1])

pd3 = ProbabilityDistribution([0.5,0.5], ["head","tails"])
pd4 = ProbabilityDistribution([0.4,0.6], ["one", "two"])

@test_throws cpt = CPT(["p|sun", :"p|clouds"], [pd3,pd4])
