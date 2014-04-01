type CPT{F <: FloatingPoint,S}
    Ps::Array{F,2}
    states::Array{S,1}

    function CPT(_PDs::Array{ProbabilityDistribution{F,S},1})
        _lPDs=length(_PDs)
        
        for i=2:_lPDs
            if _PDs[1] != _PDs[i]
                throw("State mismatch: CPT's must contain ProbabilityDistributions of the same type")
            end
        end

        s=states(_PDs[1])::Array{S,1}
        Pl=length(_PDs[1])
        Ps=Array(F,length(_PDs),Pl)

        for i=1:_lPDs
            Ps[i,:] = probabilities(_PDs[i])
        end
        
        new(Ps, s)
    end
end

CPT{F,S}(PDs::Array{ProbabilityDistribution{F,S},1}) = CPT{F,S}(PDs)

function states(cpt::CPT)
    cpt.states
end

function getindex(cpt::CPT, i::Integer)
    ProbabilityDistribution(cpt.Ps[i,:][:],states(cpt))
end
