# Check for memory leaks
using DReal
reset_ctx!()

ctx = Context(qf_nra)
X = Var(ctx, Float64,"Xleaks4", 0.0,1.0)
for i = 1:1000
  push_ctx!(ctx)
  a = rand()
  b = rand()
  add!(ctx,(<=)(ctx,X,b))
  add!(ctx,(>=)(ctx,X,a))
  is_satisfiable(ctx)
  pop_ctx!(ctx)
end