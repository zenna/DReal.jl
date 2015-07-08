using JuMP
using NLopt


e_ = Float64(e)
pi_ = Float64(π)

## Ackleys 1
function ackley(x, d::Int)
  -20*exp(-0.02 * sqrt((1/d)*sum([x[i]*x[i] for i = 1:d])) - 
    exp(1/d * sum([cos(2*pi_ * x[i]) for i = 1:d])) + 20 + e_

m = Model(solver=NLoptSolver(algorithm=:LD_MMA))
@defVar(m, -10 <= x1 <= 10.0 )        # Lower bound only (note: 'lb <= x' is not valid)
@defVar(m, -10 <= x2 <= 10.0 )        # Lower bound only (note: 'lb <= x' is not valid)

@setNLObjective(m, :Min, -1 * ((cos(x1)*cos(x2)*exp(sqrt(1 - (sqrt(x1^2 + x2^2)) / 3.141592)))^2) / 30)
  
status = solve(m)

println("Objective value: ", getObjectiveValue(m))
println("x1 = ", getValue(x1))
println("x2 = ", getValue(x2))


using DReal

m = Model(solver=DReal.DRealSolver(precision = 0.001))
@defVar(m, -10 <= x1 <= 10.0 )        # Lower bound only (note: 'lb <= x' is not valid)
@defVar(m, -10 <= x2 <= 10.0 )        # Lower bound only (note: 'lb <= x' is not valid)

@setNLObjective(m, :Min, -1 * ((cos(x1)*cos(x2)*exp(sqrt(1 - (sqrt(x1^2 + x2^2)) / 3.141592)))^2) / 30)
  
status = solve(m)

println("Objective value: ", getObjectiveValue(m))
println("x1 = ", getValue(x1))
println("x2 = ", getValue(x2))