using Graphs
using Base.Test
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

function add_node!(g::BayesianNetwork, n::BayesianNode)
    @assert vertex_index(n) == num_vertices(g) + 1
    push!(g.nodes, n)
end

function add_edge!(g::BayesianNetwork, s::BayesianNode, t::BayesianNode)
    e = ExEdge(num_edges(g) + 1, s, t)
    index = vertex_index(t)
    push!(g.nodes[index].ingoingEdges, e)
    push!(g.edges, e)
end

function add_edge!(g::BayesianNetwork, e::ExEdge{BayesianNode})
    @assert edge_index(e) == num_edges(g) + 1
    index = vertex_index(e.target)
    push!(g.nodes[index].ingoingEdges, e)
    push!(g.edges, e)
end

vertex_index(n::BayesianNode) = n.index

num_vertices(g::BayesianNetwork) = length(g.nodes)
vertices(g::BayesianNetwork) = g.nodes

num_edges(g::BayesianNetwork) = length(g.edges)
edges(g::BayesianNetwork) = g.edges

include("show.jl")
#a1 = BayesianNode(1,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2])) 
#a2 = BayesianNode(2,1,Array(ExEdge{BayesianNode},0),ProbabilityDistribution([0.5,0.5],[1,2])) 
#e1 = BayesianEdge(1,a1,a2);
