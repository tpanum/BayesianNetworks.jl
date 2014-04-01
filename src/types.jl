type CPT{F <: FloatingPoint,S}
    Ps::Array{F,2}
    states::Array{S,1}

    function CPT(_PDs::Array{ProbabilityDistribution,1})
        _lPDs=length(_PDs)
        
        for i=2:_lPDs
            if _PDs[1] != _PDs[i]
                throw("State mismatch: CPT's must contain ProbabilityDistributions of the same type")
            end
        end

        s=states(_PDs[1])
        Pl=length(_PDs[1])
        Ps=Array(Float64,length(_PDs),Pl)

        for i=1:_lPDs
            Ps[1,:] = probabilities(PDs[i])
        end
        
        new(Ps, s)
    end
end

type BayesianNode
	index::Int
    state::Int
    ingoingEdges::Array{ExEdge{BayesianNode},1}
    CPT::ProbabilityDistribution
       
    BayesianNode(i::Int, s::Int, ie::Array{ExEdge{BayesianNode},1}, c::ProbabilityDistribution) = new(i,s,ie, c)    
end

type BayesianNetwork
    nodes::Array{BayesianNode,1}
    edges::Array{ExEdge{BayesianNode},1}
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
