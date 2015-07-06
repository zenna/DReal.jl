using DReal


import DReal:  opensmt_init, opensmt_mk_context,
               opensmt_mk_real_var, opensmt_mk_eq, opensmt_assert, opensmt_check,
               opensmt_mk_sin, opensmt_mk_cos, opensmt_get_ub, opensmt_get_lb,
               opensmt_set_precision, opensmt_mk_ite, opensmt_mk_num, opensmt_mk_gt


using Compat
# A = Var(Float64, "A", 0.0, 1.0)
# B = Var(Float64, "B", 0.0, 1.0)
# # C = Var(Float64, "C", 0.0, 1.0)
# add!(B > ifelse(A>0.4, 0.3,0.4))
# add!(A>0.4)
# model(A)
# model(B)

# 
ctx = opensmt_mk_context(@compat UInt32(1))
opensmt_set_precision(ctx, 0.00001)
A = opensmt_mk_real_var( ctx, "A" , 0.0, 1.0)
B = opensmt_mk_real_var( ctx, "B" , 0.0, 1.0)

ite = opensmt_mk_ite(ctx, opensmt_mk_gt(ctx, A, opensmt_mk_num(ctx, 0.4)),
                          opensmt_mk_num(ctx, 0.3),
                          opensmt_mk_num(ctx, 0.4))
eq = opensmt_mk_gt(ctx, B, ite)
opensmt_assert( ctx, eq)
res = opensmt_check( ctx );
println("res is ", res == -1 ? "unsat" : "sat")
