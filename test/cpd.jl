@test :S | :R == (:S,:R)
@test :S | [:R, :D] == (:S, [:R, :D])
@test [:S,:G] | [:R, :D] == ([:S,:G], [:R, :D])

@test P(:S|:R) == CPD(:S,:R)
@test P([:S,:G] | [:R, :D]) == CPD([:S,:G],[:R,:D])
