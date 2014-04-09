using Graphs
using BayesianNetworks
using Base.Test

function add_test_package(file::ASCIIString)
    start_time=time()
    try
        include(file)
        delta_time=round(time()-start_time,2)
        println("[\u2713] $file ($(delta_time)s)")
    catch e
        println(e)
    end
end
add_test_package("utility.jl")
add_test_package("probability_distribution.jl")
add_test_package("cpd.jl")
add_test_package("bayesian_node.jl")
add_test_package("bayesian_network.jl")
add_test_package("bayesian_edge.jl")
add_test_package("probability_density_distribution.jl")
add_test_package("diagnosis_test.jl")
