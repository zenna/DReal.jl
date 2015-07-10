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
  name::String
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
  value, results = capture(()->eval(gen_f(a,p)), a.capture)
  reset_global_ctx!()
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
ackley1 = OptProb("ackley1", d, -35.0, 35.0, :Min,
  :(-20*exp(-0.02*sqrt((1/n)*sum{x[i]^2, i=1:n})) - 
    exp((1/n)*sum{cos(2*pi_*x[i]), i=1:n}) + 20 + e), 0.0)

ackley2 = OptProb("ackley2", 2, -32.0, 32.0, :Min,
  :(200*exp(-0.02*sqrt(x[1]^2 + x[2]^2))), -200.0)

ackley3 = OptProb("ackley3", 2, -32.0, 32.0, :Min,
  :(200*exp(-0.02*sqrt(x[1]^2 + x[2]^2)) + 5*exp(cos(3*x[1])+sin(3*x[2]))), -219.1418)

ackley4 = OptProb("ackley4", d, -35.0, 35.0, :Min,
  :(sum{exp(-0.2*sqrt(x[1]^2 + x[2]^2) + 3*(cos(2x[1]) + sin(2x[1+1]))), i=1:n-1}), -3.917275)

alpine7 = OptProb("alpine7", d, 0.0, 10.0, :Min,
  :(prod{sqrt(x[i])*sin(x[i]), i=1:n}), 2.808)

# Skip due to unequal constraints
# brad8 = OptProb("brad8", )

# 9. Skip due to abs

beale10 = OptProb("beale10", 2, -4.5, 4.5, :Min,
  :((1.5 - x[1] +x[1]*x[2])^2 + (2.25 - x[1] + x[1]*x[2]^2)^2 + (2.625 - x[1] + x[1]*x[2]^3)^2), 1.0)

biggs11 = OptProb("biggs11", 2, 0.0, 20.0, :Min,
  :(sum{(exp(-0.1*i*x[1]) - 5*exp(-0.1*i*x[2]) - (exp(-0.1*i) - 5*exp(i)))^2, i=1:n}), 0.0)

biggs12 = OptProb("biggs12", 3, 0.0, 20.0, :Min,
  :(sum{(exp(-0.1*i*x[1]) - x[3]*exp(-0.1*i*x[2]) - (exp(-0.1*i) - 5*exp(i)))^2, i=1:10}), 0.0)

biggs13 = OptProb("biggs13", 4, 0.0, 20.0, :Min,
  :(sum{(x[3]*exp(-0.1*i*x[1]) - x[4]*exp(-0.1*i*x[2]) - (exp(-0.1*i) - 5*exp(i)))^2, i=1:10}), 0.0)

biggs14 = OptProb("biggs14", 6, -20.0, 20.0, :Min,
  :(sum{(x[3]*exp(-0.1i*x[1]) - x[4]*exp(-0.1i*x[2]) + 3*exp(-0.1i*x[5]) - (exp(-0.1i) - 5*exp(i) + 3*exp(-0.4i)))^2, i=1:11}), 0.0)

biggs15 = OptProb("biggs15", 6, -20.0, 20.0, :Min,
  :(sum{(x[3]*exp(-0.1i*x[1]) - x[4]*exp(-0.1i*x[2]) + x[6]*exp(-0.1i*x[5]) - (exp(-0.1i) - 5*exp(i) + 3*exp(-0.4i)))^2, i=1:13}), 0.0)

bird16 = OptProb("bird16", 2, -2*pi_, 2*pi_, :Min,
  :(sin(x[1])*exp((1-cos(x[2])^2)) +cos(x[2])*exp((1-sin(x[1]))^2) + (x[1] - x[2])^2), -106.764537)

bohachevsky17 = OptProb("bohachevsky17", 2, -100.0, 100.0, :Min,
  :(x[1]^2 + 2*x[2]^2 - 0.3*cos(3*pi_*x[1]) - 0.4*cos(4*pi_*x[2]) + 0.7), 0.0)

bohachevsky18 = OptProb("bohachevsky18", 2, -100.0, 100.0, :Min,
  :(x[1]^2 + 2*x[2]^2 - 0.3*cos(3*pi_*x[1]) * 0.4*cos(4*pi_*x[2]) + 0.3), 0.0)

bohachevsky19 = OptProb("bohachevsky19", 2, -100.0, 100.0, :Min,
  :(x[1]^2 +2*x[2]^2 - 0.3*cos(3*pi_*x[1] + 4*pi_*x[2]) + 0.3), 0.0)

booth20 = OptProb("booth20", 2, -10.0, 10.0, :Min,
  :((x[1] + 2*x[2] - 7)^2 + (2x[1] + x[2] -5)^2), 0.0)

# Uneven Bounds
# box_betts21 = OptProb("box_betts21", )

#uneven bounds branin

branin23 = OptProb("branin23", 3, -5.0, 15.0, :Min,
  :((x[2] - (5.1x[1]^2)/(4*pi_^2) + (5x[1])/pi_ - 6)^2 +
    10*(1 - 1/(8pi_))*cos(x[1])*cos(x[2])*log(x[1]^2+x[2]^2+1) + 10), 5.559037)

brent24 = OptProb("brent24", 2, -10.0, 10.0, :Min,
  :((x[1] + 10)^2 + (x[2] + 10)^2 +exp(-x[1]^2 - x[2]^2)), 0.0)

brown25 = OptProb("brown", 4, -4.0, 4.0, :Min,
  :(sum{x[i]^(2*x[i+1]^2+1) + x[i+1]^(2*x[i]^2+1), i=1:n-1}),
  0.0)

# bukin26 = OptProb("bukin26", 2, )
camel29 = OptProb("camel29", 2, -5.0, 5.0, :Min,
  :(2x[1]^2 - 1.05x[1]^4 + (x[1]^6)/6 +x[1]*x[2] +x[2]^2), 0.0)

camel30 = OptProb("camel30", 2, -5.0, 5.0, :Min,
  :((4-2.1x[1]^2 + (x[1]^4)/3)*x[1]^2 +x[1]*x[2] + (4*x[2]^2 - 4) * x[2]^2), -1.0316)

# Contains Floor

chichinadze33 = OptProb("chichinadze33", 2, -30.0, 30.0, :Min,
  :(x[1]^2 - 12x[1] + 11 + 10*cos(pi_*x[1]/2) + 8*sin(5pi_*x[1]/2) - 
    (1/5)^0.5*exp(-0.5*(x[2] - 0.5)^2)), -43.3159)

chungreynolds34 = OptProb("chungreynolds34", d, -100.0, 100.0, :Min, 
  :((sum{x[i]^2, i=1:n})^2), 0.0)

#35 .. matrices...

# abs
# corana37 = OptProb("corana37", d, -500.0, 500.0, :Min,
#   )

# ifelset = OptProb("ifelset", 1, 0.0, 1.0, :Min,
#   :(ifelse(x[1] > 0.5), x, 2x), 10)

cosinemix38 = OptProb("cosinemix38", 4, -1.0, 1.0, :Min,
  :(-0.1 * sum{cos(5pi_*x[i]), i=1:n} - sum{x[i]^2, i=1:n}), 0.4)

csendes40 = OptProb("csendes40", d, -1.0, 1.0, :Min,
  :(sum{x[i]^6 * (2 + sin(1/x[i])), i=1:n}), 0)

cube41 = OptProb("cube41", 2, -10.0, 10.0, :Min,
  :(100*(x[2] - x[1]^3)^2 + (1-x[1])^2), 0.0)

deb43 = OptProb("deb43", d, -1.0, 1.0, :Min,
  :(-1/n * sum{sin(5*pi_*x[i])^6, i=1:n}), -Inf)

deb44 = OptProb("deb44", d, -1.0, 1.0, :Min,
  :(-1/n * sum{sin(5pi_*(x[1]^.75 - 0.05))^6, i=1:n}), -Inf)

deckkers_arts45 = OptProb("deckkers_arts45", 2, -20.0, 20.0, :Min,
  :(10^5*x[1]^2 + x[2]^2 - (x[1]^2 + x[2]^2)^2 + 10.0^-5 * (x[1]^2 + x[2]^2)^4), -2477)

rosenbrock105 = OptProb("rosenbrock105", d, -30.0, 30.0, :Min,
  :(sum{100*(x[i+1] - x[i]^2)^2 + (x[i] -1)^2, i=1:n-1}), 0.0)


ripple = OptProb("ripple", 2, 0.0, 1.0, :Min, :(sum{x[i]^(2*x[i+1]^2+1) + x[i+1]^(2*x[i]^2+1), i=1:n-1}), -Inf)
whitley = OptProb("whitley", 5, -100.0, 100.0, :Min, :(sum{((100*(x[i]^2 -x[j])^2 + (1 - x[j])^2)^2)/4000 - cos(100*(x[i]^2 - x[j])^2 + (1 - x[j])^2) + 1, i = 1:n, j = 1:n}), -1.)

## Run Experiments
problems = [ackley1, ackley2, ackley3, ackley4, alpine7, beale10, biggs11, brown, ripple, whitley]
algos = [mma, dreal, cobyla]

# results = record(algos,problems; runname = "kl",savedb=false,exceptions=true)

## 171. Xin-She
# xinshe171 = OptProb(5, -10.0, 10.0, :Min, :(exp(-sum{(x[i]/15)^(2*5), i=1:n}) - 2*exp(-sum{x[i]^2, i=1:n}), -1.0)

