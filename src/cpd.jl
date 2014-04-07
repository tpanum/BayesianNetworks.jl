type CPD
    distribution::Array{Symbol,1}
    conditionals::Array{Symbol,1}

    CPD(bn::Symbol) = new([bn],[])
    CPD(bn::Symbol, conds::Array) = new([bn],conds)
    CPD(dists::Array, bn::Symbol) = new(dists,[bn])
    CPD(bn1::Symbol, bn2::Symbol) = new([bn1],[bn2])
end

distribution(cpd::CPD) = cpd.distribution
conditionals(cpd::CPD) = cpd.conditionals

P{T <: (Symbol,Symbol)}(vals::T) = CPD(vals[1],vals[2])
P(val::Symbol) = CPD(val, Symbol[])

|(bn1::Symbol, bn2::Symbol) = (bn1,bn2)
|(bn1::Array{Symbol,1}, bn2::Array{Symbol,1}) = (bn1,bn2)
|(bn1::Symbol, bn2::Array{Symbol,1}) = (bn1,bn2)
|(bn1::Array{Symbol,1}, bn2::Symbol) = (bn1,bn2)

function ==(cpd1::CPD, cpd2::CPD)
    length(setdiff(Set(distribution(cpd1)),Set(distribution(cpd2)))) == 0 && length(setdiff(Set(conditionals(cpd1)),Set(conditionals(cpd2)))) == 0
end
