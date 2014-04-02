abstract Node

type BayesianNode <: Node
    index::Int
    label::ASCIIString
    CPT::ProbabilityDistribution
       
    function BayesianNode(i::Int, l::ASCIIString, c::ProbabilityDistribution) 
        new(i,l,c)
    end    
end

type CBayesianNode <: Node
    index::Int
    label::ASCIIString
    pdf::Function

    CBayesianNode(i::Int, l::ASCIIString, d::Distribution) = new(i, l,x->pdf(d,x))
end 

function probability(n::CBayesianNode, x)
    n.pdf(x)
end

type BayesianEdge
    index::Int
    source::Node
    target::Node

    BayesianEdge(i::Int, s::Node, t::Node) = new(i,s,t)
end

type BayesianNetwork <: AbstractGraph{Node, BayesianEdge}
    nodes::Array{Node,1}
    edges::Array{BayesianEdge,1}

    function BayesianNetwork(n::Array{Node,1}, e::Array{BayesianEdge,1}; set_ids = true)
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



#BayesianNetwork(n::Array{Node,1}, e::Array{ExEdge{Node},1}; set_ids = true) = BayesianNetwork(n,e)

function add_node!(g::BayesianNetwork, n::Node)
    @assert node_index(n) == num_nodes(g) + 1
    push!(g.nodes, n)
end

function add_edge!(g::BayesianNetwork, s::Node, t::Node)
    e = BayesianEdge(num_edges(g) + 1, s, t)
    push!(g.edges, e)
end

function add_edge!(g::BayesianNetwork, e::BayesianEdge)
    @assert edge_index(e) == num_edges(g) + 1
    push!(g.edges, e)
end

function in_neighbors(n::Node, g::BayesianNetwork)
    res = Array(BayesianNode,0)
    for edge in g.edges
        if edge.target.index == n.index
            push!(res,edge.source)
        end
    end
    res
end

function out_neighbors(n::Node, g::BayesianNetwork)
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

function node_array{V <: Node}(a::Array{V,1})
    res = Array(Node, length(a))
    for i = 1:length(a)
        res[i] = a[i]
    end
    res
end




node_index(n::BayesianNode) = n.index
node_index(n::CBayesianNode) = n.index
edge_index(e::BayesianEdge) = e.index

num_nodes(g::BayesianNetwork) = length(g.nodes)
nodes(g::BayesianNetwork) = g.nodes

num_edges(g::BayesianNetwork) = length(g.edges)
edges(g::BayesianNetwork) = g.edges
