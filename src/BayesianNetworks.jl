module BayesianNetworks

##############################################################################
##
## Dependencies
##
##############################################################################

using Graphs

include("utils.jl")
include("probability_distribution.jl")
include("probability_density_distribution.jl")
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
       group_combinations,
       joint_probability_distributions,

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
       find_node_by_symbol,
       symbols_in_network,
       node_in_network,
       nodes_in_network,
       add_probability!,
       legal_configuration,
       cached_result,

       PDistribution,
       UnknownPDistribution,
       ProbabilityDistribution,
       ProbabilityDensityDistribution,
       states,
       pdfs,
       probabilities,
       CPT,
       BayesianNode,
       DBayesianNode,
       CBayesianNode,
       probability,
       BayesianEdge,
       node_index,
       CPD,
       P,
       valid_pdfs


end
