module BayesianNetworks

##############################################################################
##
## Dependencies
##
##############################################################################

using Graphs

include("ProbabilityDistribution.jl")
include("CPT.jl")
include("types.jl")

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
       BayesianNetwork,
       BayesianEdge,
       add_node!,
       add_edge!,
       node_index,
       num_nodes,
       nodes,
       num_edges,
       edges

end
