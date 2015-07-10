using DReal
# using Gadfly

## Function Approximation
## ======================
f(x) = sin(x) + 2x

npowers = 5
θ = [DReal.Var(Float64, -10.0, 10.0) for i = 1:npowers]
g(x) = sum([θ[i]*(x^i) for i = 1:(npowers - 1)]) + θ[npowers]

x = ForallVar(global_context(), Float64, -1000.0, 1000.0)
constraint = abs(g(x) - f(x)) < 1.0

add!(constraint)
result = model(θ...)
@show result
# pop_ctx!()