function Base.show(io::IO, pd::ProbabilityDistribution)
    pds = join(pd.ps, ", ")
    print(io, "probabilities {$pds}")
end

function Base.show(io::IO, v::BayesianNode)
    print(io, "vertex [$(v.index)] ($(v.CPT), ingoing $(showEdgeList(v.ingoingEdges)))")
end

function showEdgeList(edges::Array{ExEdge{BayesianNode},1})
    if length(edges) == 0
        names = "none"
    else
        names = string("[", join(map(x -> x.index, edges), ", "), "]")
    end
    names
end
