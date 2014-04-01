#using Graphs

type ProbabilityDistribution{T <: FloatingPoint, K}
    ps::Array{T,1}
    states::Array{K,1}

    function ProbabilityDistribution(_ps::Array{T,1}, _ss::Array{K,1})
        if sum(_ps) != 1
            throw("Probability Distributions must sum to 1")
        end
        new(_ps, _ss)
    end
end

ProbabilityDistribution{T,K}(ps::Array{T,1}, ss::Array{K,1}) = ProbabilityDistribution{T,K}(ps, ss)

function states(pd::ProbabilityDistribution)
    pd.states
end

type CPT
    PDs::Array{ProbabilityDistribution,1}
end

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
