using dReal

import dReal: init_dreal!, Context, Var, add!, set_precision!, is_satisfiable, model

begin
# Blank slate
reset_ctx!()

# ## Example
# ## =======
init_dreal!()
ctx = Context(qf_nra)
set_precision!(ctx, 0.00001)
x = Var(ctx, Float64, "x", -3.141592, 3.141592)
y = Var(ctx, Float64, "y", -3.141592, 3.141592)
add!(sin(x) == cos(y))
res = is_satisfiable(ctx)
if res
  println("x = $(model(ctx,x))")
  println("y = $(model(ctx,y))")
end
end