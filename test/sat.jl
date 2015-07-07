using DReal
using Base.Test
reset_ctx!()

A = Var(Bool,"aa")
B = Var(Bool,"bb")
C = Var(Bool,"cc")

formula = add!((A & B) | C)
@show is_satisfiable()
@show a, b, c = model(A, B, C)
# @test (a & b) | c