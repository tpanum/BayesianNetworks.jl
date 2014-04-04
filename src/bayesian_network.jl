import Graphs: in_edges, in_degree, in_neighbors, out_edges, out_degree, out_neighbors

type BayesianNetwork <: AbstractGraph{BayesianNode, BayesianEdge}
    nodes::Array{BayesianNode,1}
    edges::Array{BayesianEdge,1}
    finclist::Array{Array{BayesianEdge,1},1}   #forward incidence list
    binclist::Array{Array{BayesianEdge,1},1}   #backward incidence list

    function BayesianNetwork{V <: BayesianNode}(_nodes::Array{V,1}, _edges::Array{BayesianEdge,1})
        _nodes = convert(Array{BayesianNode,1}, _nodes)
        l_nodes = length(_nodes)
        if l_nodes > 0
            map(x -> assign_index(x[2],x[1]), enumerate(_nodes))
        end
        if length(_edges) > 0
            map(x -> assign_index(x[2],x[1]), enumerate(_edges))
        end
        b = new(_nodes, Array(BayesianEdge,0), multivecs(BayesianEdge, l_nodes), multivecs(BayesianEdge, l_nodes))
        for edge in _edges
            add_edge!(b, edge)
        end
        b
    end

    function query(probability::Symbol)
    if edges[1].label == probability
        true
    end
end
end

BayesianNetwork(n::Array{None,1}, e::Array{None,1}) = BayesianNetwork(Array(BayesianNode,0),Array(BayesianEdge,0))
BayesianNetwork{V <: BayesianNode}(n::Array{V,1}) = BayesianNetwork(n,Array(BayesianEdge,0))
BayesianNetwork{V <: BayesianNode}(n::Array{V,1}, e::Array{None,1}) = BayesianNetwork(n,Array(BayesianEdge,0))
BayesianNetwork() = BayesianNetwork([], [])

num_edges(g::BayesianNetwork) = length(g.edges)
edges(g::BayesianNetwork) = g.edges

function assign_index(g_elem, i::Int)
    if g_elem.index != 0
        throw("Attempting to reassign node")
    end
    g_elem.index=i
end

function add_node!{T <: BayesianNode}(g::BayesianNetwork, n::T)
    assign_index(n, num_nodes(g) + 1)

    push!(g.nodes, n)

    # Create entries for vertex in backward and forward incidence lists
    push!(g.finclist, Int[])
    push!(g.binclist, Int[])

    n
end

add_edge!{S <: BayesianNode, T <: BayesianNode}(g::BayesianNetwork, s::S, t::T) = add_edge!(g, BayesianEdge(s,t))

function add_edge!(g::BayesianNetwork, e::BayesianEdge)
    assign_index(e, num_edges(g) + 1)

    u = source(e)
    v = target(e)

    if !nodes_in_network(g, [u, v])
        throw("Attempting to add an edge to a network where the nodes are not present")
    end
    ui = node_index(u)::Int
    vi = node_index(v)::Int

    # Add edge to network and to forward list for source and to backward list for target
    push!(g.edges, e)
    push!(g.finclist[ui], e)
    push!(g.binclist[vi], e)

    e
end

function nodes_in_network{V <: BayesianNode}(g::BayesianNetwork, ns::Array{V,1})
    for node in ns
        if !node_in_network(g,node)
            return false
        end
    end
    true
end

function node_in_network{V <: BayesianNode}(g::BayesianNetwork, n::V)
    nodes(g)[node_index(n)] == n
end

function find_node(g::BayesianNetwork, s::Symbol)
    for node in g.nodes
        if node.label == s
            return node
        end
    end
    null
end

in_edges{V <: BayesianNode}(n::V, g::BayesianNetwork) = g.binclist[node_index(n)]
in_degree{V <: BayesianNode}(n::V, g::BayesianNetwork) = length(in_edges(n, g))
in_neighbors{V <: BayesianNode}(n::V, g::BayesianNetwork) = SourceIterator(g, in_edges(n, g))

out_edges{V <: BayesianNode}(n::V, g::BayesianNetwork) = g.finclist[node_index(n)]
out_degree{V <: BayesianNode}(n::V, g::BayesianNetwork) = length(out_edges(n, g))
out_neighbors{V <: BayesianNode}(n::V, g::BayesianNetwork) = TargetIterator(g, out_edges(n, g))

edge_index(e::BayesianEdge) = e.index

num_nodes(g::BayesianNetwork) = length(g.nodes)
nodes(g::BayesianNetwork) = g.nodes

num_edges(g::BayesianNetwork) = length(g.edges)
edges(g::BayesianNetwork) = g.edges

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
getindex(a::TargetIterator, i::Integer) = target(a.lst[i])

start(a::TargetIterator) = start(a.lst)
done(a::TargetIterator, s) = done(a.lst, s)
next(a::TargetIterator, s::Int) = ((e, s) = next(a.lst, s); (target(e), s))

# iterating over sources

immutable SourceIterator{G<:AbstractGraph,EList}
    g::G
    lst::EList
end

SourceIterator{G<:AbstractGraph,EList}(g::G, lst::EList) =
    SourceIterator{G,EList}(g, lst)

length(a::SourceIterator) = length(a.lst)
isempty(a::SourceIterator) = isempty(a.lst)
getindex(a::SourceIterator, i::Integer) = source(a.lst[i])

start(a::SourceIterator) = start(a.lst)
done(a::SourceIterator, s) = done(a.lst, s)
next(a::SourceIterator, s::Int) = ((e, s) = next(a.lst, s); (source(e), s))

#################################################
#
#  CPDs
#
################################################

type CPD
    distribution::Array{BayesianNode,1}
    conditionals::Array{BayesianNode,1}

    CPD(bn::BayesianNode, conds::Array) = new([bn],conds)
    CPD(dists::Array, bn::BayesianNode) = new(dists,[bn])
    CPD(bn1::BayesianNode, bn2::BayesianNode) = new([bn1],[bn2])
end

function cpds(bn::BayesianNetwork)
    N = nodes(bn)
    res = Array(CPD, length(N))
    for i=1:length(N)
        res[i]=CPD(N[i], map(source, in_neighbors(N[i], bn).lst))
    end
    res
end

|(bn1::BayesianNode, bn2::BayesianNode) = CPD(bn1,bn2)
|(bn1::Array{BayesianNode,1}, bn2::Array{BayesianNode,1}) = CPD(bn1,bn2)
|(bn1::BayesianNode, bn2::Array{BayesianNode,1}) = CPD(bn1,bn2)
|(bn1::Array{BayesianNode,1}, bn2::BayesianNode) = CPD(bn1,bn2)    
