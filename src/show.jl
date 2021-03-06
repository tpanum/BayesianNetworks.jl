import Base: show

function show(io::IO, pd::PDistribution)
    x,y = map(length,states(pd))
    print(io, "ProbabilityDistribution{$(x)x$(y)}")
end

function show(io::IO, vd::DBayesianNode)
    print(io, "dnode [$(vd.index), $(vd.label)] $(vd.pd)")
end

function show(io::IO, vc::CBayesianNode)
    print(io, "cnode [$(vc.index), $(vc.label)]")
end

function show(io::IO, e::BayesianEdge)
    print(io, "$(e.source) --> $(e.target)")
end

function show(io::IO, cpd::CPD)
    dist=map(bn -> string(bn), cpd.distribution)
    j_dist=join(dist, ",")

    if length(cpd.conditionals) > 0
        cond=map(bn -> string(bn), cpd.conditionals)
        j_cond=join(cond, ",")
        print(io,"CPD{P($(j_dist)|$(j_cond))}")
    else
        print(io, "CPD{P($(j_dist))}")
    end
end

function show(io::IO, bn::BayesianNetwork)
    edges = showEdgeList(bn.edges)
    nodes = showNodeList(bn.nodes)
    print(io, "edges $edges, nodes $nodes")
end

function showNodeList(nodes::Array{BayesianNode,1})
    if length(nodes) == 0
        names = "none"
    else
        names = string("[", join(map(x -> x.index, nodes), ", "), "]")
    end
    names
end

function showEdgeList(edges::Array{BayesianEdge,1})
    if length(edges) == 0
        names = "none"
    else
        names = string("[", join(map(x -> x.index, edges), ", "), "]")
    end
    names
end
