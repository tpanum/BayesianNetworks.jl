# Normalization factor

@test normalize_factor([1,2]) == [1/3, 2/3]
@test normalize_factor([1 2]) == [1/3 2/3]

# Gaussian Distribution PDF's

@test typeof(normpdf(0,1)) == Function
@test_approx_eq_eps normpdf(0,1)(0) 0.399 0.0001

# Group combinations

groups=Array[["a","b"],["c","d"],["e","f","g"],["z","q"]]
grc=group_combinations(groups)

@test Set({"a","c","e","z"}) in grc
@test length(unique(grc)) == prod(map(length,groups))
@test group_combinations(Array[]) == []

# Joint probability distribution

pd1 = ProbabilityDistribution([0.4 0.1; 0.25 0.25], Array{ASCIIString,1}[["tails","head"],["happy","sad"]])
pd2 = ProbabilityDistribution([0.4 0.1; 0.25 0.25], Array{ASCIIString,1}[["tails","head"],["happy","sad"]])
a = joint_probability_distributions(pd1, pd2)
@test sum(a) == 1

