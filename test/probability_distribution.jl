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

pd4 = ProbabilityDistribution(["rain","sun"], [0.6,0.4])

j_pd1_pd4=pd1*pd4

@test length(states(j_pd1_pd4)) == 4
@test_throws p2*p3
@test_approx_eq j_pd1_pd4[Set{ASCIIString}({"head","rain"})] 0.3

# P(X|Y) * P(Y)

pd5 = ProbabilityDistribution(["x1","x2"],[0.5 0.5; 0.7 0.3],["y1","y2"])
pd6 = ProbabilityDistribution(["y1","y2"],[0.5,0.5])

pd_q=pd5*pd6
@test_approx_eq 0.15 pd_q[Set{ASCIIString}({"y2","x2"})]
@test sum(probabilities(pd_q)) == 1

pd7 = ProbabilityDistribution(["x1", "x2", "x3"],[0.34 0.33 0.33; 0.6 0.2 0.2], ["y1", "y2"])
pd8 = ProbabilityDistribution(["y1","y2"],[0.7,0.3])

pd_q1=pd7*pd8
@test sum(probabilities(pd_q1)) == 1
@test_approx_eq 0.238 pd_q1[Set{ASCIIString}({"y1","x1"})]
@test_approx_eq pd_q1[Set{ASCIIString}({"y2","x2"})] pd_q1[Set{ASCIIString}({"y2","x3"})]
@test_approx_eq 0.06 pd_q1[Set{ASCIIString}({"y2","x2"})]
@test_approx_eq 0.231 pd_q1[Set{ASCIIString}({"y1","x2"})]

pd9 = ProbabilityDistribution(["x1", "x2", "x3"],[0.34 0.33 0.33; 0.6 0.2 0.2], ["y1", "y2"])
pd10 = ProbabilityDistribution(["y2","y1"],[0.3,0.7])

pd_q2=pd9*pd10
@test sum(probabilities(pd_q2)) == 1
@test_approx_eq 0.238 pd_q2[Set{ASCIIString}({"y1","x1"})]
@test_approx_eq pd_q2[Set{ASCIIString}({"y2","x2"})] pd_q2[Set{ASCIIString}({"y2","x3"})]
@test_approx_eq 0.06 pd_q2[Set{ASCIIString}({"y2","x2"})]
@test_approx_eq 0.231 pd_q2[Set{ASCIIString}({"y1","x2"})]

pd11 = ProbabilityDistribution(["x1", "x2"],[0.5 0.5; 0.6 0.4; 0.23 0.77], ["y1", "y2", "y3"])
pd12 = ProbabilityDistribution(["y1","y3", "y2"],[0.2,0.5,0.3])

pd_q3=pd11*pd12
@test sum(probabilities(pd_q3)) == 1
@test_approx_eq 0.385 pd_q3[Set{ASCIIString}({"y3","x2"})]
@test_approx_eq 0.1 pd_q3[Set{ASCIIString}({"y1","x1"})]
@test_approx_eq 0.18 pd_q3[Set{ASCIIString}({"y2","x1"})]
@test_approx_eq 0.115 pd_q3[Set{ASCIIString}({"y3","x1"})]
@test typeof(probabilities(pd_q3)) == Array{Float64,1}

@test_approx_eq probabilities(pd_q3/pd12) probabilities(pd11)
