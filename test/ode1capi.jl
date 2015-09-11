using DReal
import DReal: opensmt_context, opensmt_set_verbosity, opensmt_assert, opensmt_check, opensmt_print_expr, opensmt_mk_context,
              opensmt_mk_bool_var, opensmt_mk_int_var, opensmt_mk_minus, opensmt_mk_leq, opensmt_mk_num_from_string,
              opensmt_push, opensmt_pop, opensmt_reset, opensmt_del_context, opensmt_mk_uminus, opensmt_mk_times_2, opensmt_mk_times_3,
              opensmt_set_precision, opensmt_mk_unbounded_real_var, opensmt_mk_num, opensmt_mk_div, opensmt_mk_sqrt, opensmt_mk_pow,
              opensmt_mk_exp, opensmt_define_ode, opensmt_mk_integral, opensmt_mk_eq, opensmt_mk_geq, opensmt_mk_real_var
using Base.Test
using Compat

ctx = opensmt_mk_context(@compat UInt32(1))
opensmt_set_precision(ctx, 1.0)

# Creating Real variables
x = opensmt_mk_real_var(ctx, "x", -100.0, 100.0)
P = opensmt_mk_real_var(ctx, "P", -100.0, 100.0)
x_0 = opensmt_mk_real_var(ctx, "x_0", -100.0, 100.0)
P_0 = opensmt_mk_real_var(ctx, "P_0", -100.0, 100.0)
x_t = opensmt_mk_real_var(ctx, "x_t", -100.0, 100.0)
P_t = opensmt_mk_real_var(ctx, "P_t", -100.0, 100.0)
time_0 = opensmt_mk_real_var(ctx, "time_0", 0.0, 100.0)

# =======================================================================
# Define ODE (flow)
# d/dt[x] = 1.0
# d/dt[P] = 1.0 / ((2.0 * 3.14159265359) ^ 0.5) * exp (- (x ^ 2) / 2.0)
zero = opensmt_mk_num(ctx, 0.0)
one = opensmt_mk_num(ctx, 1.0)
ten = opensmt_mk_num(ctx, 10.0)
neg_ten = opensmt_mk_uminus(ctx, ten)
two = opensmt_mk_num(ctx, 2.0)
pi  = opensmt_mk_num(ctx, 3.14159265359)
two_pi = opensmt_mk_times_2(ctx, two, pi)
# p_rhs = opensmt_mk_uminus(ctx, x)
p_rhs = opensmt_mk_times_2(
  ctx,
  # 1.0 / sqrt(2 * pi)
  # opensmt_mk_div(ctx, one, opensmt_mk_sqrt(ctx, two_pi)),
  opensmt_mk_div(ctx, one, opensmt_mk_pow(ctx, two_pi, opensmt_mk_num(ctx, 0.5))),
  # exp (- x^2 / 2.0)
  opensmt_mk_exp(
    ctx,
    opensmt_mk_uminus(ctx, opensmt_mk_div(ctx, opensmt_mk_pow(ctx, x, two), two))))
#
vars = [x, P]
rhses = [one, p_rhs]
opensmt_define_ode(ctx, "flow_1", vars, rhses, Cuint(2))

# =======================================================================
## Define initial and final state
opensmt_assert(ctx, opensmt_mk_eq(ctx, x_0, neg_ten))  # x_0 = -10.0
opensmt_assert(ctx, opensmt_mk_eq(ctx, P_0, zero))     # P_0 = 0.0
opensmt_assert(ctx, opensmt_mk_eq(ctx, x_t, ten))      # x_t = 10.0
opensmt_assert(ctx, opensmt_mk_geq(ctx, P_t, zero))    # P_t >= 0.0

# =======================================================================
# Add integral constraint
# [x_t P_t] = integral_0^{time_0} [x_0 P_0] | flow_1

vars_t = [x_t, P_t]
vars_0 = [x_0, P_0]
integral = opensmt_mk_integral(ctx, vars_t, zero, time_0, vars_0, Cuint(2), "flow_1")
opensmt_assert(ctx, integral)
res = opensmt_check(ctx)

println( "res = $(res == -1 ? "unsat" : "sat")")

print( "Deleting context\n" )
opensmt_del_context( ctx )
