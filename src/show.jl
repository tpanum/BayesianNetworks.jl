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
    print(io, "dnode [$(vd.index), $(vd.label)] $(vd.pd)")
end

function show(io::IO, vc::CBayesianNode)
    print(io, "cnode [$(vc.index), $(vc.label)]")
end

function show(io::IO, cpd::CPD)
    dist=map(bn -> string(bn.label), cpd.distribution)
    j_dist=join(dist, ",")

    if length(cpd.conditionals) > 0
        cond=map(bn -> string(bn.label), cpd.conditionals)
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
