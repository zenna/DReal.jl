using DReal

b = ForallVar(global_context(), Float64)
c = ForallVar(global_context(), Float64)
d = Var(Float64,-10.,10.)

f(x,y) = (x + y)*d + 6

add!(f(b,c) > 5.0)
@show is_satisfiable()
@show model(d)
