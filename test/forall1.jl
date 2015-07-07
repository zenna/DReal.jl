using DReal

b = ForallVar(Float64)
c = ForallVar(Float64)
d = Var(Float64,-10.,10.)

f(x,y) = d + 2

add!(f(b,c) > 5.0)
@show is_satisfiable()
@show model(d)
