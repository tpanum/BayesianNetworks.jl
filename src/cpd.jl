type CPD
    distribution::Array{Symbol,1}
    conditionals::Array{Symbol,1}
    parameters::Dict{Symbol, Function}

    CPD(bn::Array, conds::Array) = new(bn, conds, Dict{Symbol,Function}())
    CPD(bn::Symbol) = CPD([bn],[])
    CPD(bn::Symbol, conds::Array) = CPD([bn],conds)
    CPD(dists::Array, bn::Symbol) = CPD(dists,[bn])
    CPD(bn1::Symbol, bn2::Symbol) = CPD([bn1],[bn2])
end

distribution(cpd::CPD) = cpd.distribution
conditionals(cpd::CPD) = cpd.conditionals

P{T <: (Array{Symbol,1},Symbol)}(vals::T) = CPD(vals[1],vals[2])
P{T <: (Symbol,Array{Symbol,1})}(vals::T) = CPD(vals[1],vals[2])
P{T <: (Array{Symbol,1},Array{Symbol,1})}(vals::T) = CPD(vals[1],vals[2])
P{T <: (Symbol,Symbol)}(vals::T) = CPD(vals[1],vals[2])
P{T <: (Symbol,Dict)}(vals::T) = CPD(vals[1],vals[2])
P(val::Symbol) = CPD(val, Symbol[])
P(vals::Array{Symbol,1}) = CPD(vals, Symbol[])

|(bn1::Symbol, bn2::Symbol) = (bn1,bn2)
|(bn1::Symbol, bn2::Dict) = (bn1,bn2)
|(bn1::Array{Symbol,1}, bn2::Array{Symbol,1}) = (bn1,bn2)
|(bn1::Symbol, bn2::Array{Symbol,1}) = (bn1,bn2)
|(bn1::Array{Symbol,1}, bn2::Symbol) = (bn1,bn2)
|(bn1::Array{Symbol,1}, bn2::Dict) = (bn1,bn2)

function ==(cpd1::CPD, cpd2::CPD)
    length(setdiff(Set(distribution(cpd1)),Set(distribution(cpd2)))) == 0 && length(setdiff(Set(conditionals(cpd1)),Set(conditionals(cpd2)))) == 0
end

function isequal(cpd1::CPD, cpd2::CPD)
    length(setdiff(Set(distribution(cpd1)),Set(distribution(cpd2)))) == 0 && length(setdiff(Set(conditionals(cpd1)),Set(conditionals(cpd2)))) == 0
end
