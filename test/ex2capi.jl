using DReal
using Base.Test

import DReal:  opensmt_init, opensmt_mk_context,
               opensmt_mk_real_var, opensmt_mk_eq, opensmt_assert, opensmt_check,
               opensmt_mk_sin, opensmt_mk_cos, opensmt_get_ub, opensmt_get_lb,
               opensmt_set_precision

begin
# Blank slate
reset_ctx!()

# ## Example
# ## =======
ctx = opensmt_mk_context(@compat UInt32(1))
opensmt_set_precision(ctx, 0.00001)
x = opensmt_mk_real_var( ctx, "x" , -3.141592, 3.141592)
y = opensmt_mk_real_var( ctx, "y" , -3.141592, 3.141592)
eq = opensmt_mk_eq( ctx, opensmt_mk_sin(ctx, x), opensmt_mk_cos(ctx, y));
opensmt_assert( ctx, eq );
res = opensmt_check( ctx );
println("res is ", res == -1 ? "unsat" : "sat")
@test res == 1
if res == 1
  x_ub = opensmt_get_ub(ctx, x)
  x_lb = opensmt_get_lb(ctx, x)
  println("x = [$x_lb, $x_ub]")
  y_ub = opensmt_get_ub(ctx, y)
  y_lb = opensmt_get_lb(ctx, y)
  println("y = [$y_lb, $y_ub]")
end
end