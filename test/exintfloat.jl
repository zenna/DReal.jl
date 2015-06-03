using dReal
using Base.Test

"""
(set-logic QF_NRA)
(declare-fun x () Int)
(declare-fun y () Real)
(assert (<= 10 x))
(assert (<= x 20))
(assert (<= 30 y))
(assert (<= y 66))
(assert (<= (- (sin x) y) 0.3))
(check-sat)
(exit)
"""

# x = Var(Int, "x", 10,20)
# y = Var(Float64, "y", 30.0, 66.)
# add!(sin(x) - y <= 0.3)
# @test is_satisfiable()
# @show model(x,y)
begin
reset_global_ctx!()

x = Var(Float64, "x", -10.0, 10.0)
y = Var(Int, "y", -10, 10)
z = Var(Float64, "z", 0.0, 10.0)
add!(x-y>z)
@show is_satisfiable()
@show model(x,y,z)
end