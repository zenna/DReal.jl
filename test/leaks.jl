using DReal
using Compat
import DReal: opensmt_context, opensmt_set_verbosity, opensmt_assert, opensmt_check, opensmt_print_expr, opensmt_mk_context,
              opensmt_mk_bool_var, opensmt_mk_int_var, opensmt_mk_minus, opensmt_mk_leq, opensmt_mk_num_from_string,
              opensmt_push, opensmt_pop, opensmt_reset, opensmt_del_context, opensmt_set_precision, opensmt_mk_real_var

import DReal: opensmt_mk_geq,opensmt_mk_leq, opensmt_mk_num

i = 0;
ctx = opensmt_mk_context(@compat UInt32(1));
opensmt_set_precision (ctx, 0.0000001);
x = opensmt_mk_real_var(ctx, "leaks4x" , 0.0, 1.0);

for i=1:10000
    opensmt_push(ctx);
    lb = opensmt_mk_num(ctx, rand());
    ub = opensmt_mk_num(ctx, rand());
    # print(lb,ub)
    geq = opensmt_mk_geq(ctx, x, lb);
    leq = opensmt_mk_leq(ctx, x, ub);
    opensmt_assert(ctx, geq);
    opensmt_assert(ctx, leq);
    res = opensmt_check( ctx );
    # println(res == 0 ? "unsat" : "sat" );
    opensmt_pop(ctx);
end
opensmt_del_context(ctx);