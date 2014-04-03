module BayesianNetworks

##############################################################################
##
## Dependencies
##
##############################################################################

using Graphs

include("probability_distribution.jl")
include("cpt.jl")
include("bayesian_node.jl")
include("bayesian_edge.jl")
include("bayesian_network.jl")
include("show.jl")

##############################################################################
##
## Exports
##
##############################################################################

export ProbabilityDistribution,
       states,
       probabilities,
       CPT,
       BayesianNode,
       DBayesianNode,
       CBayesianNode,
       probability,
       BayesianEdge,
       BayesianNetwork,
       add_node!,
       add_edge!,
       node_index,
       num_nodes,
       nodes,
       num_edges,
       edges,
       CPD,
       cpds,
       find_node

end
