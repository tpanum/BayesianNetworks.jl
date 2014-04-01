module BayesianNetworks

##############################################################################
##
## Dependencies
##
##############################################################################

using Graphs

include("ProbabilityDistribution.jl")
include("types.jl")

##############################################################################
##
## Exports
##
##############################################################################

export ProbabilityDistribution,
       states,
       probabilities,
       CPT

end
