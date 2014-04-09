import Graphs: in_edges, in_degree, in_neighbors, out_edges, out_degree, out_neighbors
import Base: isempty

type BayesianNetwork <: AbstractGraph{BayesianNode, BayesianEdge}
    nodes::Array{BayesianNode,1}
    edges::Array{BayesianEdge,1}

    finclist::Array{Array{BayesianEdge,1},1}   #forward incidence list
    binclist::Array{Array{BayesianEdge,1},1}   #backward incidence list

    cpds::Dict{CPD,Any} ## Add types if needed

    function BayesianNetwork{V <: BayesianNode}(_nodes::Array{V,1}, _edges::Array{BayesianEdge,1})
        _nodes = convert(Array{BayesianNode,1}, _nodes)
        l_nodes = length(_nodes)
        _cpds=Dict{CPD, Any}()
        if l_nodes > 0
            map(x -> assign_index(x[2],x[1]), enumerate(_nodes))
            for _n in _nodes
                if has_pd(_n)
                    _cpds[CPD(_n.label)] = _n.pd
                end
            end
        end
        if length(_edges) > 0
            map(x -> assign_index(x[2],x[1]), enumerate(_edges))
        end
        b = new(_nodes, Array(BayesianEdge,0), multivecs(BayesianEdge, l_nodes), multivecs(BayesianEdge, l_nodes), _cpds)
        for edge in _edges
            add_edge!(b, edge)
        end
        b
    end
end

BayesianNetwork(n::Array{None,1}, e::Array{None,1}) = BayesianNetwork(Array(BayesianNode,0),Array(BayesianEdge,0))
BayesianNetwork{V <: BayesianNode}(n::Array{V,1}) = BayesianNetwork(n,Array(BayesianEdge,0))
BayesianNetwork{V <: BayesianNode}(n::Array{V,1}, e::Array{None,1}) = BayesianNetwork(n,Array(BayesianEdge,0))
BayesianNetwork() = BayesianNetwork([], [])

nodes(g::BayesianNetwork) = g.nodes
num_nodes(g::BayesianNetwork) = length(nodes(g))

edges(g::BayesianNetwork) = g.edges
num_edges(g::BayesianNetwork) = length(edges(g))

cpds(g::BayesianNetwork) = g.cpds
num_cpds(g::BayesianNetwork) = length(cpds(g))

function assign_index(g_elem, i::Int)
    if g_elem.index != 0
        throw("Attempting to reassign node")
    end
    g_elem.index=i
end

function add_node!{T <: BayesianNode}(g::BayesianNetwork, n::T)
    ##Update what is put into the cpds dictionary when decided
    if typeof(n) == DBayesianNode && has_pd(n)
        g.cpds[CPD(n.label, [])] = n.pd
        ##Check just made in case someone construct a graph in an non-obvious manner, will probably not be run
        if length(in_edges(n, g)) > 0
            g.cpds[CPD(n.label, [edge.source.label for edge in in_edges(n, g)])] = null
        end
    else
        g.cpds[CPD(n.label, [   ])] = null
    end
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
    add_cpd_for_edge!(g,u,v)

    e
end

function add_cpd_for_edge!(g::BayesianNetwork, s::BayesianNode,t::BayesianNode)
    if typeof(s) == DBayesianNode && has_pd(s) && has_pd(t)
        g.cpds[CPD(t.label, [edge.source.label for edge in in_edges(t,g)])] = null
    else
        g.cpds[CPD(t.label, s.label)] = null
    end
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
    if node_index(n) > length(nodes(g)) || node_index(n) == 0
        false
    else
        nodes(g)[node_index(n)] == n
    end
end

function symbols_in_network(g::BayesianNetwork, ss::Array{Symbol,1})
    for s in ss
        if find_node_by_symbol(g,s) == false
            return false
        end
    end
    true
end

function find_node_by_symbol(g::BayesianNetwork, s::Symbol)
    for node in g.nodes
        if node.label == s
            return node
        end
    end
    false
end

function in_edges{V <: BayesianNode}(n::V, g::BayesianNetwork)
    if !node_in_network(g, n)
        Array{BayesianEdge,1}[]
    else
        g.binclist[node_index(n)]
    end
end

in_degree{V <: BayesianNode}(n::V, g::BayesianNetwork) = length(in_edges(n, g))
in_neighbors{V <: BayesianNode}(n::V, g::BayesianNetwork) = map(e -> e.source, in_edges(n, g))

function out_edges{V <: BayesianNode}(n::V, g::BayesianNetwork)
    if !node_in_network(g, n)
        Array{BayesianEdge,1}[]
    else
        g.finclist[node_index(n)]
    end
end

out_degree{V <: BayesianNode}(n::V, g::BayesianNetwork) = length(out_edges(n, g))
out_neighbors{V <: BayesianNode}(n::V, g::BayesianNetwork) = map(e -> e.target, out_edges(n, g))

function add_probability!{V <: PDistribution}(g::BayesianNetwork, cpd::CPD, pd::V)
    if symbols_in_network(g, distribution(cpd)) && symbols_in_network(g, conditionals(cpd))
        g.cpds[cpd] = pd
        true
    else
        false
    end
end

function joint_probability_distribution(bn::BayesianNetwork, cpd::CPD)
    if length(conditionals(cpd)) == 0
        [ P(d|in_neighbors(d)) for d in distribution(cpd) ]
    end
end

multivecs{T}(::Type{T}, n::Int) = [T[] for _ =1:n]

#################################################
#
#  query
#
################################################

function legal_configuration(bn::BayesianNetwork, cpd::CPD)
    nodes = Set(cpd.conditionals)
    size = 0
    checkedNodes = Set()
    uncheckedNodes = Set()
    for label in cpd.distribution
        uncheckedNodes = union(Set(gather_nodes_by_edge_out(out_edges(find_node_by_symbol(bn,label), bn))), gather_nodes_by_edge_in(in_edges(find_node_by_symbol(bn,label), bn)))
    end
    while 0 < length(uncheckedNodes)
        for node in uncheckedNodes
            inNodes = gather_nodes_by_edge_in(in_edges(find_node_by_symbol(bn,node.label), bn))
            outNodes = gather_nodes_by_edge_out(out_edges(find_node_by_symbol(bn,node.label), bn))
            union!(uncheckedNodes, setdiff(inNodes,checkedNodes))
            union!(uncheckedNodes, setdiff(outNodes,checkedNodes))
            push!(checkedNodes,node)
            delete!(uncheckedNodes,node)
        end
    end

    for node in checkedNodes
        if node.label in nodes
            delete!(nodes,node.label)
        end
    end
    if isempty(nodes)
        true
    else
        false
    end
end

gather_nodes_by_edge_in(edges::Array{BayesianEdge,1}) = Set(map(edge -> edge.source, edges))

gather_nodes_by_edge_out(edges::Array{BayesianEdge,1}) = Set(map(edge -> edge.target, edges))

function check_requirements(g::BayesianNetwork, cpd::CPD)
    conds = conditionals(cpd)
    dist = distribution(cpd)
    to_check = [P(conds|dist), P(conds), P(dist)]
    for i in to_check
        if get_cpd(g, i) == false
            return false
        end
    end
    true
end

function get_cpd(g::BayesianNetwork, cpd::CPD)
    try
        getindex(cpds(g),cpd)
    catch
        false
    end
end

function cached_result(bn::BayesianNetwork, cpd::CPD)
    if cpd in collect(keys(bn.cpds))
        bn.cpds[cpd]
    else
        throw("Maybe a bit aggresive to throw an error for the cpd not being in the network, but oh well for now")
    end
end
