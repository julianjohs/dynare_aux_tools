#=
dists.jl - Prior distributions and their moments (Author: Julian Johs)
need to calculate mean and standard deviation of used distributions to use them in Dynare

beta_moments calculates mean and standard deviation of Beta distribution
giving plot as argument plots the distribution

beta_solve uses beta_moments to calculate parameters α and β for given
mean and standard deviation - this should give you a feeling for what Dynare does
beta_solve takes 2 real numbers as inputs

the same applies for the functions for the Gamma distribution
=#
using Distributions, StatsPlots, NLsolve

function beta_moments(params::Tuple{Real, Real}; plot=nothing)#; plot::Bool=false
    α = params[1]
    β = params[2]
    dist = Beta(α, β)
    mu = mean(dist)
    sig = std(dist)
    if plot !== nothing
        display(plot(dist)) # you can comment this out
     end
    return (mu, sig)
end
beta_moments(α::Real, β::Real; args...) = beta_moments((α, β); args...)
beta_moments(params::AbstractArray{<:Real, 1}; args...) = beta_moments((params[1], params[2]); args...)

function beta_solve(m::Real, s::Real)
    solver = nlsolve(params -> beta_moments(params) .- (m, s), [1.0, 1.0])
    return solver.zero
end
beta_solve(params::AbstractArray{<:Real, 1}) = beta_solve(params[1], params[2])
beta_solve(params::Tuple{Vararg{<:Real}}) = beta_solve(params[1], params[2])


function gamma_moments(params::Tuple{Real, Real}; plot=nothing)
    α = params[1]
    β = params[2]
    dist = Gamma(α, β)
    mu = mean(dist)
    sig = std(dist)
    if plot !== nothing
        display(plot(dist)) # you can comment this out
    end
    return (mu, sig)
end
gamma_moments(α::Real, β::Real; args...) = gamma_moments((α, β); args...)
gamma_moments(params::AbstractArray{<:Real, 1}; args...) = gamma_moments((params[1], params[2]); args...)


function gamma_solve(m::Real, s::Real)
    solver = nlsolve(params -> gamma_moments(params) .- (m, s), [1.0, 1.0])
    return solver.zero
end
gamma_solve(params::AbstractArray{<:Real, 1}) = gamma_solve(params[1], params[2])
gamma_solve(params::Tuple{Vararg{<:Real}}) =    gamma_solve(params[1], params[2])

function invgamma_moments(params::Tuple{Real, Real}; plot=nothing)
    α = params[1]
    β = params[2]
    dist = InverseGamma(α, β)
    mu = mean(dist)
    sig = std(dist)
    if plot !== nothing
        display(plot(dist)) # you can comment this out
    end
    return (mu, sig)
end
invgamma_moments(α::Real, β::Real; args...) = invgamma_moments((α, β); args...)
invgamma_moments(params::AbstractArray{<:Real, 1}; args...) = invgamma_moments((params[1], params[2]); args...)

function invgamma_solve(m::Real, s::Real; ftol=1e-12)
    solver = nlsolve(params -> invgamma_moments(params) .- (m, s), [2.1, 0.2])
    return solver.zero
end
invgamma_solve(params::AbstractArray{<:Real, 1}) = invgamma_solve(params[1], params[2])
invgamma_solve(params::Tuple{Vararg{<:Real}}) =    invgamma_solve(params[1], params[2])
