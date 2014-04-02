import Graphs: in_edges, in_degree, in_neighbors, out_edges, out_degree, out_neighbors

type BayesianNetwork <: AbstractGraph{BayesianNode, ExEdge{BayesianNode}}
    nodes::Array{BayesianNode,1}
    edges::Array{ExEdge{BayesianNode},1}
    finclist::Array{Array{ExEdge{BayesianNode},1},1}   #forward incidence list
    binclist::Array{Array{ExEdge{BayesianNode},1},1}   #backward incidence list

    function BayesianNetwork(_nodes::Array{BayesianNode,1}, _edges::Array{ExEdge{BayesianNode},1})
        l_nodes = length(_nodes)
        if l_nodes > 0
            map(x -> assign_index(x[2],x[1]), enumerate(_nodes))
        end
        if length(_edges) > 0
            map(x -> assign_index(x[2],x[1]), enumerate(_edges))
        end
        b = new(_nodes, Array(ExEdge{BayesianNode},0), multivecs(ExEdge{BayesianNode}, l_nodes), multivecs(ExEdge{BayesianNode}, l_nodes))
        for edge in _edges
            add_edge!(b, edge)
        end
        b
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

    # Create entries for vertex in backward and forward incidence lists
    push!(g.finclist, Int[])
    push!(g.binclist, Int[])

    n
end

add_edge!(g::BayesianNetwork, s::BayesianNode, t::BayesianNode) = add_edge!(g, BayesianEdge(s,t))

function add_edge!(g::BayesianNetwork, e::ExEdge{BayesianNode})
    @assert edge_index(e) == 0
    assign_index(e, num_edges(g) + 1)

    u = source(e)
    v = target(e)
    ui = node_index(u)::Int
    vi = node_index(v)::Int

    # Add edge to network and to forward list for source and to backward list for target
    push!(g.edges, e)
    push!(g.finclist[ui], e)
    push!(g.binclist[vi], e)

    e
end

in_edges(n::BayesianNode, g::BayesianNetwork) = g.binclist[node_index(n)]
in_degree(n::BayesianNode, g::BayesianNetwork) = length(in_edges(n, g))
in_neighbors(n::BayesianNode, g::BayesianNetwork) = SourceIterator(g, in_edges(n, g))

out_edges(n::BayesianNode, g::BayesianNetwork) = g.finclist[node_index(n)]
out_degree(n::BayesianNode, g::BayesianNetwork) = length(out_edges(n, g))
out_neighbors(n::BayesianNode, g::BayesianNetwork) = TargetIterator(g, out_edges(n, g))

num_nodes(g::BayesianNetwork) = length(g.nodes)
nodes(g::BayesianNetwork) = g.nodes

multivecs{T}(::Type{T}, n::Int) = [T[] for _ =1:n]

#################################################
#
#  iteration
#
################################################

# iterating over targets

immutable TargetIterator{G<:AbstractGraph,EList}
    g::G
    lst::EList
end

TargetIterator{G<:AbstractGraph,EList}(g::G, lst::EList) =
    TargetIterator{G,EList}(g, lst)

length(a::TargetIterator) = length(a.lst)
isempty(a::TargetIterator) = isempty(a.lst)
getindex(a::TargetIterator, i::Integer) = target(a.lst[i], a.g)

start(a::TargetIterator) = start(a.lst)
done(a::TargetIterator, s) = done(a.lst, s)
next(a::TargetIterator, s::Int) = ((e, s) = next(a.lst, s); (target(e, a.g), s))

# iterating over sources

immutable SourceIterator{G<:AbstractGraph,EList}
    g::G
    lst::EList
end

SourceIterator{G<:AbstractGraph,EList}(g::G, lst::EList) =
    SourceIterator{G,EList}(g, lst)

length(a::SourceIterator) = length(a.lst)
isempty(a::SourceIterator) = isempty(a.lst)
getindex(a::SourceIterator, i::Integer) = source(a.lst[i], a.g)

start(a::SourceIterator) = start(a.lst)
done(a::SourceIterator, s) = done(a.lst, s)
next(a::SourceIterator, s::Int) = ((e, s) = next(a.lst, s); (source(e, a.g), s))