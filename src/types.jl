type BayesianNode{V}
    index::Int
    label::ASCIIString
    state::V
    states::Array{V,1}
    CPT::CPT
       
    function BayesianNode(i::Int, l::ASCIIString, s::V, ss::Array{V,1}, c::CPT) 
        if s in ss
            new(i,l,s,ss,c)
        else 
            throw("Set state is not in the set of allowed states for the node")
        end
    end    
end

BayesianNode{V}(i::Int, l::ASCIIString, s::V, ss::Array{V,1}, c::CPT) = BayesianNode{V}(i,l,s,ss,c)  

type BayesianNetwork{V} <: AbstractGraph{BayesianNode{V}, ExEdge{BayesianNode{V}}}
    nodes::Array{BayesianNode{V},1}
    edges::Array{ExEdge{BayesianNode{V}},1}

    function BayesianNetwork(n::Array{BayesianNode{V},1}, e::Array{ExEdge{BayesianNode{V}},1}; set_ids = true)
        if set_ids == true
            for i = 1:length(n)
                if i != n[i].index
                    nindex = n[i].index
                    for j = 1:length(e)
                        if e[j].target == nindex
                            e.target = i
                        end
                    end
                    n[i].index = i
                end
            end
            for i = 1:length(e)
                e[i].index = i
            end
            new(n,e)
        else
            new(n,e)
        end
    end
end

BayesianNetwork{V}(n::Array{BayesianNode{V},1}, e::Array{ExEdge{BayesianNode{V}},1}; set_ids = true) = BayesianNetwork{V}(n,e)

function BayesianEdge(i::Int, s::BayesianNode, t::BayesianNode)
	e = ExEdge(i,s,t)
	e
end

function add_node!(g::BayesianNetwork, n::BayesianNode)
    @assert node_index(n) == num_nodes(g) + 1
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

function find_node(g::BayesianNetwork, s::ASCIIString)
    for node in g.nodes
        if node.label == s
            return node
        end
    end
    NaN
end


node_index(n::BayesianNode) = n.index

num_nodes(g::BayesianNetwork) = length(g.nodes)
nodes(g::BayesianNetwork) = g.nodes

num_edges(g::BayesianNetwork) = length(g.edges)
edges(g::BayesianNetwork) = g.edges
