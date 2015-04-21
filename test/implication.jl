using dReal
using Base.Test
a = Var(Bool,"a")
b = Var(Bool,"b")
a → b
a,b =  model(a,b)
@show a,b
@test !a | b