using DReal

a = Var(Float64,"aexpop2",0.,1.)
b2 = (a < 0.1) | (a > 0.9)
push_ctx!()
add!(b2)
is_satisfiable()
pop_ctx!()
push_ctx!()
b3 = !b2
#b3 = (a >= 0.1) & (a <= 0.9)
add!(b3)
is_satisfiable()
