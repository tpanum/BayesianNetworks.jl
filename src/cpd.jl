type CPD
    distribution::Array{Symbol,1}
    conditionals::Array{Symbol,1}

    CPD(bn::Symbol) = new([bn],[])
    CPD(bn::Symbol, conds::Array) = new([bn],conds)
    CPD(dists::Array, bn::Symbol) = new(dists,[bn])
    CPD(bn1::Symbol, bn2::Symbol) = new([bn1],[bn2])
end

function Base.show(io::IO, cpd::CPD)
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

|(bn1::Symbol, bn2::Symbol) = CPD(bn1,bn2)
|(bn1::Array{Symbol,1}, bn2::Array{Symbol,1}) = CPD(bn1,bn2)
|(bn1::Symbol, bn2::Array{Symbol,1}) = CPD(bn1,bn2)
|(bn1::Array{Symbol,1}, bn2::Symbol) = CPD(bn1,bn2)
