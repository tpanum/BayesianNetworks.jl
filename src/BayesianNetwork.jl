type BayesianNetwork <: AbstractGraph{BayesianNode, ExEdge{BayesianNode}}
    nodes::Array{BayesianNode,1}
    edges::Array{ExEdge{BayesianNode},1}

    function BayesianNetwork(_nodes::Array{BayesianNode,1}, _edges::Array{ExEdge{BayesianNode},1})
        if length(_nodes) > 0
            map(x -> assign_index(x[2],x[1]), enumerate(_nodes))
        end
        if length(_edges) > 0
            map(x -> assign_index(x[2],x[1]), enumerate(_edges))
        end
        new(_nodes,_edges)
    end
end

BayesianNetwork(n::Array{None,1}, e::Array{None,1}) = BayesianNetwork(Array(BayesianNode,0),Array(ExEdge{BayesianNode},0))
BayesianNetwork(n::Array{BayesianNode,1}) = BayesianNetwork(n,Array(ExEdge{BayesianNode},0))
BayesianNetwork(n::Array{BayesianNode,1}, e::Array{None,1}) = BayesianNetwork(n,Array(ExEdge{BayesianNode},0))
BayesianNetwork() = BayesianNetwork([], [])

num_edges(g::BayesianNetwork) = length(g.edges)
edges(g::BayesianNetwork) = g.edges

function assign_index(g_elem, i::Int)
    if g_elem.index != 0
        throw("Attempting to reassign node")
    end
    g_elem.index=i
end

function add_node!(g::BayesianNetwork, n::BayesianNode)
    assign_index(n, num_nodes(g) + 1)
    push!(g.nodes, n)
end

function add_edge!(g::BayesianNetwork, s::BayesianNode, t::BayesianNode)
    e = ExEdge(num_edges(g) + 1, s, t)
    index = node_index(t)
    push!(g.edges, e)
end

function add_edge!(g::BayesianNetwork, e::ExEdge{BayesianNode})
    @assert edge_index(e) == num_edges(g) + 1
    index = node_index(e.target)
    push!(g.edges, e)
end

function in_neighbors(n::BayesianNode, g::BayesianNetwork)
    res = Array(BayesianNode,0)
    for edge in g.edges
        if edge.target.index == n.index
            push!(res,edge.source)
        end
    end
    res
end

function out_neighbors(n::BayesianNode, g::BayesianNetwork)
    res = Array(BayesianNode,0)
    for edge in g.edges
        if edge.source.index == n.index
            push!(res,edge.target)
        end
    end
    res
end

num_nodes(g::BayesianNetwork) = length(g.nodes)
nodes(g::BayesianNetwork) = g.nodes
