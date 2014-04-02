type BayesianNode
    index::Int
    label::Symbol
    pb::ProbabilityDistribution

    function BayesianNode(_label::Symbol, _pb::ProbabilityDistribution)
        new(0, _label, _pb)
    end
end

node_index(n::BayesianNode) = n.index
