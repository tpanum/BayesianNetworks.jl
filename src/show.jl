function Base.show(io::IO, pd::ProbabilityDistribution)
    pds = join(pd.ps, ", ")
    print(io, "probabilities {$pds}")
end

function Base.show(io::IO, v::BayesianNode)
    print(io, "vertex [$(v.index)] $(v.CPT)")
end

function showEdgeList(edges::Array{ExEdge{BayesianNode},1})
    if length(edges) == 0
        names = "none"
    else
        names = string("[", join(map(x -> x.index, edges), ", "), "]")
    end
    names
end

function showNodeList(nodes::Array{BayesianNode,1})
    if length(nodes) == 0
        names = "none"
    else
        names = string("[", join(map(x -> x.index, nodes), ", "), "]")
    end
    names
end

function Base.show(io::IO, bn::BayesianNetwork)
    edges = showEdgeList(bn.edges)
    nodes = showNodeList(bn.nodes)
    print(io, "edges $edges, nodes $nodes")
end
