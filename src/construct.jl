## For Contructing and Querying Models
## ===================================

## Arithmetic
## ===========
(-){T<:Real}(ctx::Context, x::Ex{T}, y::Ex{T}) = Ex{T}(opensmt_mk_minus(ctx.ctx,x.e,y.e))
(==){T}(ctx::Context, x::Ex{T}, y::Ex{T}) = Ex{Bool}(opensmt_mk_eq(ctx.ctx,x.e,y.e))
cos{T<:Real}(ctx::Context, x::Ex{T}) = Ex{T}(opensmt_mk_cos(ctx.ctx, x.e))
sin{T<:Real}(ctx::Context, x::Ex{T}) = Ex{T}(opensmt_mk_sin(ctx.ctx, x.e))

## Queries
## =======
@doc "Is predicate Y satisfiable?" ->
is_satisfiable(ctx::Context) = [false,"UNKNOWN",true][opensmt_check(ctx.ctx)+2]

@doc "Return a model from the solver"
function model(ctx::Context, e::Ex{Float64})
  #TODO, check dirty
  Interval(opensmt_get_lb(ctx.ctx,e.e), opensmt_get_ub(ctx.ctx,e.e))
end

@doc "Return a model from the solver"
function model(ctx::Context, e::Ex{Bool})
  #TODO, check dirty
  opensmt_get_bool(ctx.ctx, e.e)
end

@doc "Add (assert) a constraint to the solver" ->
function add!(ctx::Context, e::Ex{Bool})
  opensmt_assert(ctx.ctx, e.e)
end