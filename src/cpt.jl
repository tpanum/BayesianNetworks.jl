type CPT{F <: FloatingPoint,K}
    Ps::Array{F,2}
    states::Array{ASCIIString,1}
    keys::Dict{K,Integer}

    function CPT(_Ns::Array{K,1},_PDs::Array{ProbabilityDistribution{F},1})
        _lPDs=length(_PDs)
        _lNs=length(_Ns)        

        if _lPDs != _lNs
            throw("Length mismatch of keys and probability distributions")
        end

        for i=2:_lPDs
            if _PDs[1] != _PDs[i]
                throw("State mismatch: CPT's must contain ProbabilityDistributions of the same type")
            end
        end

        s=states(_PDs[1])::Array{ASCIIString,1}
        Pl=length(_PDs[1])
        Ps=Array(F,length(_PDs),Pl)
        k=Dict{K,Integer}(_Ns,[1:_lPDs])
        for i=1:_lPDs
            Ps[i,:] = probabilities(_PDs[i])
        end
        
        new(Ps, s, k)
    end
end

CPT{F,K}(Ns::Array{K,1},PDs::Array{ProbabilityDistribution{F},1}) = CPT{F,K}(Ns,PDs)

function states(cpt::CPT)
    cpt.states
end

function getindex(cpt::CPT, key)
    ProbabilityDistribution(cpt.Ps[cpt.keys[key],:][:],states(cpt))
end


