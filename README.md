# BayesianNetworks.jl

[![Build Status](https://travis-ci.org/tpanum/BayesianNetworks.jl.png)](https://travis-ci.org/tpanum/BayesianNetworks.jl)

This is a package that allows for the construction of Bayesian Networks in [Julia](http://julialang.org/). ¨
Since the package is undergoing heavy development at the moment, there exists currently no documentation.
However take a look in the [test folder](https://github.com/tpanum/BayesianNetworks.jl/tree/master/test) for currently implmented methods and their usage.

```
> c1 = DBayesianNode(:coin, ProbabilityDistribution(["head","tails"],[0.5,0.5]))
> c2 = DBayesianNode(:super_coin, ProbabilityDistribution(["head","tails"],[0.2,0.8])
> bn = n1 = BayesianNetwork([c1, c2])

> pd = bn.query(P([:c1,:c2]))
> probabilities(pd)
[0.1, 0.4, 0.1, 0.4]
```

The packaged is developed by @bjarkehs, @esbenpm and @tpanum.