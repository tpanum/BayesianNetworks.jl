D=DBayesianNode(:D, ["d1","d2","d_water"])

a1=CBayesianNode(:a1)
a2=CBayesianNode(:a2)
a3=CBayesianNode(:a3)

bn=BayesianNetwork([D,a1,a2])

add_edge!(bn,D,a1)
add_edge!(bn,D,a2)

analysis=[a1,a2]

# Distributions

using Distributions

pdfNodeDict = Dict{Symbol, Array{Function,1}}()

for a in analysis
    a_d1_dist = Normal(rand(1:200), rand(1:15))
    a_d1_func = x -> pdf(a_d1_dist,x)
    a_d2_dist = Normal(rand(200:400), rand(1:15))
    a_d2_func = x -> pdf(a_d2_dist,x)

    samples = [ rand(dist) for i=1:100, dist in [a_d1_dist, a_d2_dist] ]

    a_d_water_pdf = x -> 1/(maximum(samples) - minimum(samples))

    pdfNodeDict[a.label] = [a_d1_func, a_d2_func, a_d_water_pdf]

    add_probability!(bn, P(a.label|:D), ProbabilityDensityDistribution(states(D), [a_d1_func, a_d2_func, a_d_water_pdf]))
end

l_states_d = length(states(D))
add_probability!(bn, P(:D), ProbabilityDistribution(states(D), fill(1/l_states_d, l_states_d)))
inputDict = Dict{Symbol,Any}({:a1 => 30, :a2 => 30})
testCPD = P(:D|inputDict)
diagProbs = query(bn,testCPD)

# Normalize results of query so we can compare
normalized_diagProbs = normalize_factor(convert(Array{Float64,1},collect(values(diagProbs))))

# For all a in analysis, run every function of a and give it the input defined in inputDict. The reducing steps performs an element-wise multiplication, and finally it's normalized.
calculatedDiagProbs = normalize_factor(reduce(.*, [ map(x -> x(inputDict[a.label]), pdfNodeDict[a.label]) for a in analysis ]))

# Test if the two normalized arrays are approximately equal
@test sum(map(x -> isapprox(normalized_diagProbs[x[1]], calculatedDiagProbs[x[1]]), enumerate(calculatedDiagProbs))) == l_states_d

#bn.query(P(:D|{:a1 => 30, :a2 => 250, a_d_water_pdf => 0}))
