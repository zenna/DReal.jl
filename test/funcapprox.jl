using DReal
# using Gadfly

## Function Approximation
## ======================

# f(x) = 2*x
# f(x) = ifelse(x > 0, sin(x), x*2)
f(x) = sin(x) + x*2

npowers = 10
θ = [DReal.Var(Float64, -10.0, 10.0) for i = 1:npowers]
g(x) = sum([θ[i]*(x^i) for i = 1:(npowers - 1)]) + θ[npowers]
# g(x) = θ[2]*x + θ[1] + θ[3]*x*x


x = ForallVar(global_context(), Float64, -10.0, 10.0)
constraint = g(x) == f(x)

# push_ctx!()
add!(constraint)
# is_satisfiable()
result = model(θ...)
@show result
# pop_ctx!()