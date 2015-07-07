using JuMP
using NLopt

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