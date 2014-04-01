pd1 = ProbabilityDistribution([0.5,0.5], ["head","tails"])
pd2 = ProbabilityDistribution([0.5,0.5], ["tails","head"])
cpt = CPT([pd1,pd2])

@test CPT[1]==pd1
