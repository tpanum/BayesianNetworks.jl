using Graphs
using BayesianNetworks
using Base.Test

function add_test_package(file::ASCIIString)
    start_time=time()
    try
        include(file)
        delta_time=round(time()-start_time,2)
        print("[")
        print_with_color(:green,"\e[92m\u2713\e[0m")
        print("] $file ($(delta_time)s)\n") 
    catch e
        println("[\e[31mx\e[0m] $file")
        throw(e)
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
