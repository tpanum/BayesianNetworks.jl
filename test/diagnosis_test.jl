D=DBayesianNode(:D, ["d1","d2","d_water"])

a1=CBayesianNode(:a1)
a2=CBayesianNode(:a2)
a3=CBayesianNode(:a3)

bn=BayesianNetwork([D,a1,a2,a3])

add_edge!(bn,D,a1)
add_edge!(bn,D,a2)
add_edge!(bn,D,a3)

analysis=[a1,a2,a3]

# Distributions

using Distributions

for a in analysis
    a_d1_dist = Normal(rand(1:200), rand(1:15))
    a_d2_dist = Normal(rand(200:400), rand(1:15))

    samples = [ rand(dist) for i=1:100, dist in [a_d1_dist, a_d2_dist] ]

    a_d_water_pdf = x -> 1/(maximum(samples) - minimum(samples))

    add_probability!(bn, P(a.label|:D), ProbabilityDensityDistribution(states(D), [x -> pdf(a_d1_dist,x), x -> pdf(a_d2_dist,x), a_d_water_pdf]))
end

add_probability!(bn, P(:D), ProbabilityDistribution(["d1","d2","d_water"], [0.4,0.4,0.2]))
#test = P(:D|Dict{Symbol,Any}({:a1 => 30, :a2 => 250}))
#aq = testquery(bn,test)

#bn.query(P(:D|{:a1 => 30, :a2 => 250, a_d_water_pdf => 0}))
