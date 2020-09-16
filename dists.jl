#=
dists.jl - Prior distributions and their moments (Author: Julian Johs)
need to calculate mean and standard deviation of used distributions to use them in Dynare

beta_moments calculates mean and standard deviation of Beta distribution
beware: beta_moments takes 1x2 Tuple as input

beta_solve uses beta_moments to calculate parameters α and β for given
mean and standard deviation - this should give you a feeling for what Dynare does
beta_solve takes 2 real numbers as inputs

the same applies for the functions for the Gamma distribution
=#
using Distributions, StatsPlots, NLsolve

beta_moments = function((params))
    α = params[1]
    β = params[2]
    dist = Beta(α, β)
    mu = mean(dist)
    sig = std(dist)
    display(plot(dist)) # you can comment this out
    mu, sig
end

beta_solve = function(m, s)
    solver = nlsolve((params) -> beta_moments(params) .- (m, s), [1.0, 1.0])
    return solver.zero
end

gamma_moments = function((params))
    α = params[1]
    β = params[2]
    dist = Gamma(α, β)
    mu = mean(dist)
    sig = std(dist)
    display(plot(dist)) # you can comment this out
    mu, sig
end

gamma_solve = function(m, s)
    solver = nlsolve((params) -> gamma_moments(params) .- (m, s), [1.0, 1.0])
    return solver.zero
end
