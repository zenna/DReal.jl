using JuMP
using DReal

m = Model(solver=DReal.DRealSolver(precision = 0.001))
@defVar(m, -10 <= x <= 10)
@setNLObjective(m, :Min, x^2*(x-1)*(x-2))
  status = solve(m)
println("Objective value: ", getObjectiveValue(m))
println("x = ", getValue(x))

f(x) = x^2*(x-1)*(x-2)
y = ForallVar(Float64, -10.0, 10.0)
x = Var(Float64)

add!(f(x) <= f(y))

using DReal
f(x) = x^2*(x-1)*(x-2)
x = Var(Float64, -100., 100.)
obj = Var(Float64, -100., 100.)
add!(obj == f(x))
result = minimize(obj, x, lb= -100., ub=100.)