using DReal

b = ForallVar(DReal.global_context(), Float64)
c = ForallVar(DReal.global_context(), Float64)
d = Var(Float64,-10.,10.)

f(x,y) = d + 2

add!(f(b,c) > 5.0)
@show is_satisfiable()
@show model(d)
