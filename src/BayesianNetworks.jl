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
include("cpd.jl")
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

       # Bayesian Network
       BayesianNetwork,
       add_node!,
       add_edge!,
       nodes,
       num_nodes,
       edges,
       num_edges,
       cpds,
       num_cpds,
       find_node,
       node_in_network,
       nodes_in_network,

       ProbabilityDistribution,
       states,
       probabilities,
       CPT,
       BayesianNode,
       DBayesianNode,
       CBayesianNode,
       probability,
       BayesianEdge,
       node_index,
       CPD

end
