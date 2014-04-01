pd1 = ProbabilityDistribution([0.5,0.5], ["head","tails"])
pd2 = ProbabilityDistribution([0.4,0.6], ["tails","head"])
cpt = CPT([pd1,pd2])

@test cpt[1]==pd1
@test cpt[2]==pd2
