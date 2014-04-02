module BayesianNetworks

##############################################################################
##
## Dependencies
##
##############################################################################

using Graphs
using Distributions

include("ProbabilityDistribution.jl")
include("CPT.jl")
include("types.jl")
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
       BayesianNode,,
       CBayesianNode
       BayesianNetwork,
       BayesianEdge,
       add_node!,
       add_edge!,
       node_index,
       num_nodes,
       nodes,
       num_edges,
       edges,
       in_neighbors,
       out_neighbors,
       find_node

end
