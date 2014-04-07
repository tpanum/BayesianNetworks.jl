D=DBayesianNode(:D, ["d1","d2","d_water"])

a1=CBayesianNode(:a1)
a2=CBayesianNode(:a2)
a3=CBayesianNode(:a3)

bn=BayesianNetwork([D,a1,a2,a3])

add_edge!(bn,D,a1)
add_edge!(bn,D,a2)
add_edge!(bn,D,a3)

add_probability!(bn, cpd(:a1|D), ProbabilityDensityDistribution(states(D), [ ... functions ... ]))
add_probability!(bn, cpd(:a2|D), ProbabilityDensityDistribution(states(D), [ ... functions ... ]))
add_probability!(bn, cpd(:a3|D), ProbabilityDensityDistribution(states(D), [ ... functions ... ]))
