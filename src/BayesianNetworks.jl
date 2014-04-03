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
include("BayesianNode.jl")
include("BayesianEdge.jl")
include("BayesianNetwork.jl")
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
