type ProbabilityDensityDistribution{V}
	states::Array{V,1}
	pdfs::Array{Function,1}

	function ProbabilityDensityDistribution{V}(_states::Array{V,1}, _pdfs::Array{Function,1})
		if length(_states) == length(_pdfs) && valid_pdfs(_pdfs)
			new(_states,_pdfs)
		else
			throw("Mismatch between number of states and pdfs when constructing ProbabilityDensityDistribution")
		end
	end
end

ProbabilityDensityDistribution{V}(_states::Array{V,1}, _pdfs::Array{Function,1}) = ProbabilityDensityDistribution{V}(_states,_pdfs)

function valid_pdfs(pdfs::Array{Function,1})
	for f in pdfs
		verify_real_to_real(f)
	end
	true
end

states(pdd::ProbabilityDensityDistribution) = pdd.states
pdfs(pdd::ProbabilityDensityDistribution) = pdd.pdfs
