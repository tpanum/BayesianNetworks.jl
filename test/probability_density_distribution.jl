pdd = ProbabilityDensityDistribution(["hej","farvel"],[x->x+1,x -> x+1])

@test ["hej","farvel"] == states(pdd)
@test_throws pdd = ProbabilityDensityDistribution(["hej","farvel","måske"],[x->x+1,x -> x+1])
@test_throws pdd = ProbabilityDensityDistribution(["hej","farvel","måske"],[x->x+1,x -> x+1, x -> "hej"])
