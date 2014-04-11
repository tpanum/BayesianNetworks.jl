function rand_pdist(n::Integer)
    collect(partitions(100,n))[rand(1:end)]/100
end

prod_time = 0
div_time = 0

amount_of_operations = 10000

for i=1:amount_of_operations
    q = rand_pdist(3)''
    
    pd1 = ProbabilityDistribution(["x1", "x2"], hcat(ones(Float64, length(q), 1) - q, q), ["y1", "y2", "y3"])
    pd2 = ProbabilityDistribution(["y1","y3", "y2"],rand_pdist(3))

    prod_time += @elapsed res = pd1*pd2
    div_time += @elapsed res/pd2
end

println("Average time to compute the multiplication product between a 3x2 PD and a 3x1 PD: $(prod_time/amount_of_operations*1000)ms")
println("Average time to compute divition product between a 3x2 PD and a 3x1 PD: $(div_time/amount_of_operations*1000)ms")
