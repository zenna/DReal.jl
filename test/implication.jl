using DReal
using Base.Test
reset_ctx!()

a = Var(Bool,"a")
b = Var(Bool,"b")
add!(a → b) # \rightarrow - equivalent to implies(a,b)
a,b =  model(a,b)
@show a,b
@test !a | b