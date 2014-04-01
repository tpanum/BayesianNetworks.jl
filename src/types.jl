#using Graphs
include("ProbabilityDistribution.jl")

type BayesianNode
	index::Int
    state::Int
    ingoingEdges::Array{ExEdge{BayesianNode},1}
    CPT::ProbabilityDistribution
       
    BayesianNode(i::Int, s::Int, ie::Array{ExEdge{BayesianNode},1}, c::ProbabilityDistribution) = new(i,s,ie, c)    
end

type BayesianNetwork <: AbstractGraph{BayesianNode, ExEdge{BayesianNode}}
    nodes::Array{BayesianNode,1}
    edges::Array{ExEdge{BayesianNode},1}

    BayesianNetwork(n::Array{BayesianNode,1}, e::Array{ExEdge{BayesianNode},1}) = new(n,e)  
end

function BayesianEdge(i::Int, s::BayesianNode, t::BayesianNode)
	e = ExEdge(i,s,t)
	push!(t.ingoingEdges, e)
	e
end
#include("show.jl")
#a1 = BayesianNode(1,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2])) 
#a2 = BayesianNode(2,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2])) 
#e1 = BayesianEdge(1,a1,a2);
