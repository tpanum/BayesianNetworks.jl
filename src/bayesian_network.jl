import Graphs: in_edges, in_degree, in_neighbors, out_edges, out_degree, out_neighbors
import Base: isempty

type BayesianNetwork <: AbstractGraph{BayesianNode, BayesianEdge}
    nodes::Array{BayesianNode,1}
    edges::Array{BayesianEdge,1}

    finclist::Array{Array{BayesianEdge,1},1}   #forward incidence list
    binclist::Array{Array{BayesianEdge,1},1}   #backward incidence list

    cpds::Dict{CPD,Any} ## Add types if needed
    checked_cpds::Dict{CPD,Uint8} # Keep a list of having or not: 0 = not processed, 1 = being processed, 2 = not derivable, 3 = derivable

    function BayesianNetwork{V <: BayesianNode}(_nodes::Array{V,1}, _edges::Array{BayesianEdge,1})
        _nodes = convert(Array{BayesianNode,1}, _nodes)
        l_nodes = length(_nodes)
        _cpds=Dict{CPD, Any}()
        _checked_cpds=Dict{CPD,Uint8}()
        if l_nodes > 0
            map(x -> assign_index(x[2],x[1]), enumerate(_nodes))
            for _n in _nodes
                if has_pd(_n)
                    if length(probabilities(_n.pd)) > 0
                        _cpds[P(_n.label)] = _n.pd
                        _checked_cpds[P(_n.label)] = 0
                    end
                end
            end
        end
        if length(_edges) > 0
            map(x -> assign_index(x[2],x[1]), enumerate(_edges))
        end
        b = new(_nodes, Array(BayesianEdge,0), multivecs(BayesianEdge, l_nodes), multivecs(BayesianEdge, l_nodes), _cpds, _checked_cpds)
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

checked_cpds(g::BayesianNetwork) = g.checked_cpds
num_checked_cpds(g::BayesianNetwork) = length(calculated_cpds(g))

function reset_checked_cpds!(g::BayesianNetwork)
    for i in collect(keys(checked_cpds(g)))
        checked_cpds(g)[i] = 0
    end
end

function set_cpd_derivable!(g::BayesianNetwork, cpd::CPD, value::Bool)
    v = value ? 3 : 2
    checked_cpds(g)[cpd] = v
end

function cpd_derivable(g::BayesianNetwork, cpd::CPD)
    if (check_checked_cpd(g, cpd))
        checked_cpds(g)[cpd] == 3
    else
        false
    end
end

function start_processing_cpd!(g::BayesianNetwork, cpd::CPD)
    checked_cpds(g)[cpd] = 1
end

function cpd_is_processing(g::BayesianNetwork, cpd::CPD)
    if check_checked_cpd(g, cpd)
        checked_cpds(g)[cpd] == 1
    else
        false
    end
end

function cpd_has_been_processed(g::BayesianNetwork, cpd::CPD)
    if check_checked_cpd(g, cpd)
        checked_cpds(g)[cpd] > 1
    else
        false
    end
end

function check_checked_cpd(g::BayesianNetwork, cpd::CPD)
    try
        getindex(checked_cpds(g), cpd)
        true
    catch
        false
    end
end

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

    ##Update what is put into the cpds dictionary when decided
    if typeof(n) == DBayesianNode && has_pd(n)
        add_probability!(g, P(n.label), n.pd)
        ##Check just made in case someone construct a graph in an non-obvious manner, will probably not be run
        if length(in_edges(n, g)) > 0
            add_probability!(g, P(n.label|[edge.source.label for edge in in_edges(n, g)]))
        end
    else
        add_probability!(g, P(n.label))
    end

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
        # g.cpds[CPD(t.label, [edge.source.label for edge in in_edges(t,g)])] = null
    else
        # g.cpds[CPD(t.label, s.label)] = null
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

add_probability!{V <: PDistribution}(g::BayesianNetwork, cpd::CPD, pd::V) = _add_probability!(g, cpd, pd)
add_probability!(g::BayesianNetwork, cpd::CPD) = _add_probability!(g, cpd, nothing)

function _add_probability!(g::BayesianNetwork, cpd::CPD, pd)
    if symbols_in_network(g, distribution(cpd)) && symbols_in_network(g, conditionals(cpd))
        g.cpds[cpd] = pd
        checked_cpds(g)[cpd] = 0
        true
    else
        false
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
    reset_checked_cpds!(g)
    _check_requirements(g, cpd)
end

function _check_requirements(g::BayesianNetwork, cpd::CPD)
    if cpd_has_been_processed(g, cpd)
        cpd_derivable(g, cpd)
    else
        if check_cpd(g, cpd)
            set_cpd_derivable!(g, cpd, true)
            true
        elseif cpd_is_processing(g, cpd)
            false
        else
            start_processing_cpd!(g, cpd)

            val = false
            conds = copy(conditionals(cpd))
            l_conds = length(conds)
            dist = copy(distribution(cpd))
            l_dist = length(dist)
            # If there are conditionals, then try bayes rule
            if l_conds > 0 && check_bayes_rule(g, cpd)
                val = true
            # If there are more than one distribution and there are conditionals, then try to split it
            elseif l_dist > 1 && l_conds > 0 && check_split_distribution(g, cpd)
                val = true
            # If there are more than one distribution but no conditionals
            elseif l_dist > 1 && l_conds == 0 && check_joint_probability_distribution(g, cpd)
                val = true
            end
            set_cpd_derivable!(g, cpd, val)
            val
        end
    end
end

function check_split_distribution(g::BayesianNetwork, cpd::CPD)
    conds = copy(conditionals(cpd))
    dist = copy(distribution(cpd))

    new_dists = 0
    if length(dist) > 1
        new_dists = splice!(dist, 2:length(dist))
    else
        throw("Length of distribution must be larger than 1.")
    end
    _check_requirements(g, P(new_dists|conds)) && _check_requirements(g, P(dist|conds))
end

function check_bayes_rule(g::BayesianNetwork, cpd::CPD)
    conds = copy(conditionals(cpd))
    dist = copy(distribution(cpd))

    opposite = P(conds|dist)
    if _check_requirements(g, opposite)
        to_check = [P(conds), P(dist)]
        for i in to_check
            if !_check_requirements(g, i)
                return false
            end
        end
        true
    else
        false
    end
end

function check_joint_probability_distribution(bn::BayesianNetwork, cpd::CPD)
    for d in distribution(cpd)
        node = find_node_by_symbol(bn, d)
        parent_labels = convert(Array{Symbol,1}, map(p -> p.label, in_neighbors(node, bn)))
        if !_check_requirements(bn, P(d|parent_labels))
            return false
        end
    end
    true
end

function check_cpd(g::BayesianNetwork, cpd::CPD)
    try
        getindex(cpds(g), cpd)
        true
    catch
        false
    end
end

function cached_result(bn::BayesianNetwork, cpd::CPD)
    if cpd in collect(keys(cpds(bn)))
        cpds(bn)[cpd]
    else
        false
    end
end

function query(bn::BayesianNetwork, cpd::CPD)
    if is_naive_bayes_model(bn, cpd)
        query_naive_bayes(bn,cpd)
    else
        throw("Form of cpd not supported by query at the moment")
    end
end

function is_naive_bayes_model(bn::BayesianNetwork, cpd::CPD)
    if typeof(find_node_by_symbol(bn,distribution(cpd)[1])) == DBayesianNode
        for label in conditionals(cpd)
            if !(typeof(find_node_by_symbol(bn, label)) == CBayesianNode)
                return false
            end
        end
    else
        false
    end
    true
end

function query_naive_bayes(bn::BayesianNetwork, cpd::CPD)
    res = Dict()
    if legal_configuration(bn,cpd)
        if cached_result(bn,cpd) != false
            res = cached_result(bn,cpd)
        elseif check_requirements(bn, cpd)
            res = calculate_probabilities(bn,cpd)
        else
            throw("Invalid configuration")
        end
    end
    res
end

function calculate_probabilities(bn::BayesianNetwork, cpd::CPD)
    res = Dict()
    temp = create_probabilities(cpd)
    for p in temp
        calculate_probability!(res, cached_result(bn, p), cpd.parameters[p.distribution[1]])
    end
    for key in keys(res)
        res[key] = get_probability(bn, find_node_by_symbol(bn,cpd.distribution[1]), key)*prod(res[key])
    end
    res
end

function get_probability(bn::BayesianNetwork, node::BayesianNode, state)
    pd = cached_result(bn, P(node.label))
    if state in states(pd)
        probabilities(pd)[findfirst(states(pd),state)]
    else
        throw("State not in node")
    end
end

create_probabilities(cpd::CPD) = map(c -> P(c|cpd.distribution), cpd.conditionals)

function calculate_probability!(dict, dist::ProbabilityDensityDistribution, v)
    for state in states(dist)
        if !(state in collect(keys(dict)))
            dict[state] = Array(Float64,0)
        end
    end

    for i = 1:length(states(dist))
        push!(dict[states(dist)[i]],pdfs(dist)[i](v))
    end
end
