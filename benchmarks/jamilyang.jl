## Optimisation Benchmarks from Jamil, Yang 2013
## =============================================

using DynamicAnalysis
import DynamicAnalysis: benchmark

using Lens
using MathProgBase
using JuMP
using DReal
using NLopt

e_ = convert(Float64, e)
pi_ = convert(Float64, π)

type OptProb <: Problem
  n::Int
  lb::Float64
  ub::Float64
  sense::Symbol
  obj::Expr
  min::Float64
end

type OptAlgo <: Algorithm
  solver::MathProgBase.MathProgSolverInterface.AbstractMathProgSolver
  capture::Vector{Symbol}
end

# Benchmark an algorithm against a optimization problem
function benchmark(a::OptAlgo, p::OptProb)
  eval(gen_f(a,p))
  value, results = capture(()->eval(gen_f(a,p)), a.capture)
  results
end

function gen_f(a::OptAlgo, p::OptProb)
  quote
    m = Model(solver = $(a.solver))
    n = $(p.n)
    @defVar(m, $(p.lb) <= x[1:$(p.n)] <= $(p.ub))
    @setNLObjective(m, :Min , $(p.obj))
    @time solve(m)
    @show obj_val = getObjectiveValue(m)
    lens(:objective_val, obj_val)  
  end
end

## Algorithms
## ==========
dreal = OptAlgo(DRealSolver(precision = 0.001), [:objective_val])
mma = OptAlgo(NLoptSolver(algorithm=:LD_MMA), [:objective_val])
cobyla = OptAlgo(NLoptSolver(algorithm=:LN_COBYLA), [:objective_val])

## Problems
## ========
d = 5
ackley1 = OptProb(d, -35.0, 35.0, :Min,
  :(-20*exp(-0.02*sqrt((1/n)*sum{x[i]^2, i=1:n})) - 
    exp((1/n)*sum{cos(2*pi_*x[i]), i=1:n}) + 20 + e), 0.0)

ackley2 = OptProb(2, -32.0, 32.0, :Min,
  :(200*exp(-0.02*sqrt(x[1]^2 + x[2]^2))), -200.0)

ackley3 = OptProb(2, -32.0, 32.0, :Min,
  :(200*exp(-0.02*sqrt(x[1]^2 + x[2]^2)) + 5*exp(cos(3*x[1])+sin(3*x[2]))), -219.1418)

ackley4 = OptProb(d, -35.0, 35.0, :Min,
  :(sum{exp(-0.2*sqrt(x[1]^2 + x[2]^2) + 3*(cos(2x[1]) + sin(2x[1+1]))), i=1:n-1}), -3.917275)

alpine7 = OptProb(d, 0.0, 10.0, :Min,
  :(prod{sqrt(x[i])*sin(x[i]), i=1:n}), 2.808)

# Skip due to unequal constraints
# brad8 = OptProb()

# 9. Skip due to abs

beale10 = OptProb(2, -4.5, 4.5, :Min,
  :((1.5 - x[1] +x[1]*x[2])^2 + (2.25 - x[1] + x[1]*x[2]^2)^2 + (2.625 - x[1] + x[1]*x[2]^3)^2), 1.0)

biggs11 = OptProb(2, 0.0, 20.0, :Min,
  :(sum{(exp(-0.1*i*x[1]) - 5*exp(-0.1*i*x[2]) - exp(-0.1*i) - 5*exp(i))^2, i=1:n}), 0.0)

brown = OptProb(4, -4.0, 4.0, :Min,
  :(sum{x[i]^(2*x[i+1]^2+1) + x[i+1]^(2*x[i]^2+1), i=1:n-1}),
  0.0)

ripple = OptProb(2, 0.0, 1.0, :Min, :(sum{x[i]^(2*x[i+1]^2+1) + x[i+1]^(2*x[i]^2+1), i=1:n-1}), -Inf)
whitley = OptProb(5, -100.0, 100.0, :Min, :(sum{((100*(x[i]^2 -x[j])^2 + (1 - x[j])^2)^2)/4000 - cos(100*(x[i]^2 - x[j])^2 + (1 - x[j])^2) + 1, i = 1:n, j = 1:n}), -1.)

## Run Experiments
problems = [ackley1, ackley2, ackley3, ackley4, alpine7, beale10, biggs11, brown, ripple, whitley]
algos = [dreal, cobyla]

@show record(algos,problems; runname = "kl",savedb=false,exceptions=true)

## 171. Xin-She
# xinshe171 = OptProb(5, -10.0, 10.0, :Min, :(exp(-sum{(x[i]/15)^(2*5), i=1:n}) - 2*exp(-sum{x[i]^2, i=1:n}), -1.0)


# ## 25. Brown Function
# # DReal
# n_25 = 4
# # m_dreal = Model(solver=DReal.DRealSolver(precision = 0.001))
# m_dreal = Model()
# m_dreal = Model(solver=NLoptSolver(algorithm=:LD_MMA))
# m_dreal = Model(solver=NLoptSolver(algorithm=:LN_COBYLA))

# @defVar(m_dreal, -4 <= x[1:n_25] <= 4)
# @setNLObjective(m_dreal, :Min , sum{x[i]^(2*x[i+1]^2+1) + x[i+1]^(2*x[i]^2+1), i=1:n_25-1})
# @time solve(m_dreal)


# # IOpt
# n_25 = 4
# m_dreal = Model()
# @defVar(m_dreal, -4 <= x[1:n_25] <= 4)
# @setNLObjective(m_dreal, :Min , sum{x[i]^(2*x[i+1]^2+1) + x[i+1]^(2*x[i]^2+1), i=1:n_25-1}))
# solve(m_dreal)

# :(@setNLObjective(m_dreal, :Min, $expr))



# ## 38. Cosine Mixture Function
# n_38 = 4
# @defExpr(cos38, -0.1 * sum{cos(5*pi_*x[i])} - sum{x[i]^2})

# ## 103. Ripple
# n_103 = 2
# ripplef(x) = sum([-exp(-2*log(2)*((x[i]-0.1)/0.8)^2) * sin(5*pi_*x[1])^6 + 0.1*cos(500 * pi_ *x[i])^2 for i=1:n_103])

# m_dreal = Model(solver=DRealSolver(precision = 0.001))
# m_dreal = Model()
# m_dreal = Model(solver=NLoptSolver(algorithm=:LD_MMA))
# m_dreal = Model(solver=NLoptSolver(algorithm=:LN_COBYLA))


# @defVar(m_dreal, 0 <= x[1:n_103] <= 1)
# @setNLObjective(m_dreal, :Min, sum{-exp(-2*log(2)*((x[i]-0.1)/0.8)^2) * sin(5*pi_*x[1])^6 + 0.1*cos(500 * pi_ *x[i])^2, i=1:n_103})
# @time solve(m_dreal)
# sol = getValue(x)

# m = Model()
# @defVar(m, 0 <= x[1:n_103] <= 1)
# @setNLObjective(m, :Min, sum{-exp(-2*log(2)*((x[i]-0.1)/0.8)^2) * sin(5*pi_*x[1])^6 + 0.1*cos(500 * pi_ *x[i])^2, i=1:2})
# solve(m)
# sol = getValue(x)

# m_nl = Model(solver=NLoptSolver(algorithm=:LN_COBYLA))
# @defVar(m_nl, 0 <= x[1:n_103] <= 1)
# # @setNLObjective(m_nl, :Min, sum{-exp(-2*log(2)*((x[i]-0.1)/0.8)^2) * sin(5*pi_*x[1])^6 + 0.1*cos(500 * pi_ *x[i])^2, i=1:2})
# @setNLObjective(m_nl, :Min, abs(x[1]))

# ## 167. Whitley
# n_167 = 3
# f(x) = sum([((100*(x[i]^2 -x[j])^2 + (1 - x[j])^2)^2)/4000 - cos(100*(x[i]^2 - x[j])^2 + (1 - x[j])^2) + 1 for i = 1:n_167, j = 1:n_167])
# x = [Var(Float64, -10000.0, 10000.0) for i = 1:n_167]
# y = [ForallVar(Float64, -10000.0, 10000.0) for i = 1:n_167]
# add!(f(x) <= f(y))
# is_satisfiable()

# n_167 = 5
# # m_dreal = Model(solver=DRealSolver(precision = 0.001))
# m_dreal = Model(solver=DRealSolver(precision = 0.001))

# m_dreal = Model(solver=DRealSolver(precision = 0.001))
# m_dreal = Model()
# m_dreal = Model(solver=NLoptSolver(algorithm=:LD_MMA))
# m_dreal = Model(solver=NLoptSolver(algorithm=:LN_COBYLA))


# @defVar(m_dreal, x[1:n_167])
# @setNLObjective(m_dreal, :Min, sum{((100*(x[i]^2 -x[j])^2 + (1 - x[j])^2)^2)/4000 - cos(100*(x[i]^2 - x[j])^2 + (1 - x[j])^2) + 1, i = 1:n_167, j = 1:n_167})
# @time solve(m_dreal)

# ## 171. Xin-She
# n_171 = 5
# β = 15
# m = 5

# m_dreal = Model(solver=DRealSolver(precision = 0.001))

# m_dreal = Model()
# m_dreal = Model(solver=NLoptSolver(algorithm=:LD_MMA))
# m_dreal = Model(solver=NLoptSolver(algorithm=:LN_COBYLA))


# @defVar(m_dreal, 0 <= x[1:n_171] <= 1)
# @setNLObjective(m_dreal, :Min, exp(-sum{(x[i]/β)^(2m), i=1:n_171}) - 2*exp(-sum{x[i]^2, i=1:n_171}) * prod{cos(x[i])^2, i = 1:n_171})
# @time solve(m_dreal)

# m_dreal = Model()
# @defVar(m_dreal, 0 <= x[1:n_171] <= 1)
# @setNLObjective(m_dreal, :Min, exp(-sum{(x[i]/β)^(2m), i=1:n_171}) - 2*exp(-sum{x[i]^2, i=1:n_171}) * prod{cos(x[i])^2, i = 1:n_171})
# solve(m_dreal)


# println("Objective value: ", getObjectiveValue(m))
# println("x1 = ", getValue(x1))
# println("x2 = ", getValue(x2))