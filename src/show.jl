import Base: show

function show(io::IO, pd::ProbabilityDistribution)
    pds = ""
    for i=1:length(pd.ps)
        if i != 1
            pds *= ", "
        end
        pds *= "$(pd.states[i]): $(pd.ps[i])"
    end
    print(io, "probabilities {$pds}")
end

function show(io::IO, vd::DBayesianNode)
    print(io, "dnode [$(v.index), $(v.label)] $(v.pb)")
end

function show(io::IO, vc::CBayesianNode)
    print(io, "cnode [$(v.index), $(v.label)]")
end

function showEdgeList(edges::Array{BayesianEdge,1})
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

function show(io::IO, bn::BayesianNetwork)
    edges = showEdgeList(bn.edges)
    nodes = showNodeList(bn.nodes)
    print(io, "edges $edges, nodes $nodes")
end

function show(io::IO, cpt::CPT)
    indencies=sortperm(collect(values(cpt.keys)))
    orderedkeys=collect(keys(cpt.keys))[indencies]
    states = "none"
    if length(orderedkeys) > 0
        states = join(cpt.states, ", ")
    end
    print(io, "cpt: {$states}")
    for i=1:length(orderedkeys)
        println(io,"")
        probs = join(cpt.Ps[i,:], ", ")
        print(io, " [$(orderedkeys[i])] {$(probs)}")
    end
end
