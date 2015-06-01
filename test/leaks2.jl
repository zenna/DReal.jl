using dReal

ctx = Context(qf_nra)
X = Var(ctx, Float64,"X", 0.0,1.0)
add!(ctx,(<=)(ctx,X,0.3))
for i = 1:100000
  push_ctx!(ctx)
  a = rand()
  b = rand()
  add!(ctx,(>=)(ctx,X,0.1))
  is_satisfiable(ctx)
  pop_ctx!(ctx)
end