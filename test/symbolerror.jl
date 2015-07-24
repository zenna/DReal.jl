using DReal

ctx = global_context()
X = Var(Float64, 0.0, 1.0)
exgold = (X < 0.5) | (X > 0.9) 
notex = (!)(ctx, exgold)

ex = exgold
push_ctx!(ctx)
lb_constraint = (>=)(ctx, X, 0.0)
DReal.add!(ctx, lb_constraint)
ub_constraint = (<=)(ctx, X, 1.0)
DReal.add!(ctx, ub_constraint)
DReal.add!(ctx, ex)
result = is_satisfiable(ctx)
pop_ctx!(ctx)

ex = notex
push_ctx!(ctx)
lb_constraint = (>=)(ctx, X, 0.0)
DReal.add!(ctx, lb_constraint)
ub_constraint = (<=)(ctx, X, 1.0)
DReal.add!(ctx, ub_constraint)
DReal.add!(ctx, ex)
result = is_satisfiable(ctx)
pop_ctx!(ctx)

ex = exgold
push_ctx!(ctx)
lb_constraint = (>=)(ctx, X, 0.0)
DReal.add!(ctx, lb_constraint)
ub_constraint = (<=)(ctx, X, 0.5)
DReal.add!(ctx, ub_constraint)
DReal.add!(ctx, ex)
result = is_satisfiable(ctx)
pop_ctx!(ctx)

ex = notex
push_ctx!(ctx)
lb_constraint = (>=)(ctx, X, 0.0)
DReal.add!(ctx, lb_constraint)
ub_constraint = (<=)(ctx, X, 0.5)
DReal.add!(ctx, ub_constraint)
DReal.add!(ctx, ex)

DReal.is_satisfiable()