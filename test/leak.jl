# Check for memory leaks
using DReal
ctx = Context(qf_nra)
X = Var(ctx, Float64,"X", 0.0,1.0)
for i = 1:10000
  push_ctx!(ctx)
  a = rand()
  b = rand()
  add!(ctx,(<=)(ctx,X,b))
  add!(ctx,(>=)(ctx,X,a))
  is_satisfiable(ctx)
  pop_ctx!(ctx)
end