a1 = DBayesianNode(:hulu, pd1)
a2 = DBayesianNode(:bulu, pd2)
b3 = CBayesianNode(:esben, x->x^0.5)

e1 = BayesianEdge(a1,a2)
e2 = BayesianEdge(a1,b3)

@test edge_index(e1) == 0
@test edge_index(e2) == 0
@test source(e1) == a1
@test target(e1) == a2
@test target(e2) == b3
@test_throws e2 = BayesianEdge(b3,a1)