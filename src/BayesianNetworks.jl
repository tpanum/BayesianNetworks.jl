module BayesianNetworks

##############################################################################
##
## Dependencies
##
##############################################################################

using Graphs

include("utils.jl")
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

export

       # Utils
       normalize_factor,
       normpdf,

       ProbabilityDistribution,
       states,
       probabilities,
       CPT,
       DBayesianNode,
       CBayesianNode,
       BayesianNetwork,
       BayesianEdge,
       BayesianNode,
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
