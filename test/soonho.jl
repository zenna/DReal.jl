using DReal

## Function Approximation
## ======================

f(x) = x*2 / sin(x)
θ = [Var(Float64, -10.0, 10.0) for i = 1:7]
# g(x) = θ[1] + θ[2]*x + θ[3]*x^2 + θ[4]*x^3

g(x) = θ[1] + θ[2]*x^θ[3] + θ[4]*x^θ[5] + θ[6]*x^θ[7]

x = ForallVar(Float64, 0.0, 10.0)
constraint = g(x) == f(x)
constraint = (g(x) * f(x)) < 10
constraint = abs(g(x) - f(x)) < 1.0 # However, this (incorrectly) is UNSAT
add!(constraint)
@show is_satisfiable()
# result = model(θ...)
# @show result