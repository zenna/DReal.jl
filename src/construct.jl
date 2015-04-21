## For Contructing and Querying Models
## ===================================

# TODO
# Make this lifting more compact


## Conversion
## ==========
import Base: convert, push!

convert{T<:Real}(::Type{Ex{T}}, ctx::Context, x::T) = opensmt_mk_num_from_string(ctx.ctx, string(x))
convert{T<:Real}(t::Type{Ex{T}}, x::T) = convert(t,global_context(),x)

## Arithmetic
## ==========

boolop2opensmt = @compat Dict(:(=>) => opensmt_mk_geq, :(>) => opensmt_mk_gt,
                              :(<=) => opensmt_mk_leq, :(<) => opensmt_mk_lt,
                              :(==) => opensmt_mk_eq)

for (op,opensmt_func) in boolop2opensmt
  @eval ($op){T<:Real}(ctx::Context, x::Ex{T}, y::Ex{T}) = Ex{Bool}($opensmt_func(ctx.ctx,x.e,y.e))
  # Var and constant c
  @eval ($op){T<:Real}(ctx::Context, x::Ex{T}, c::T) = Ex{Bool}($opensmt_func(ctx.ctx,x.e,convert(Ex{T},c)))
  @eval ($op){T<:Real}(ctx::Context, c::T, y::Ex{T}) = Ex{Bool}($opensmt_func(ctx.ctx,convert(Ex{T},c),x.e))
  
  # Default Contex
  @eval ($op){T<:Real}(x::Ex{T},y::Ex{T}) = ($op)(global_context(), x, y)
  @eval ($op){T<:Real}(c::T,x::Ex{T}) = ($op)(global_context(), c, x)
  @eval ($op){T<:Real}(x::Ex{T},c::T) = ($op)(global_context(), x, c)
end

# (-)
(-){T<:Real}(ctx::Context, x::Ex{T}, y::Ex{T}) = Ex{T}(opensmt_mk_minus(ctx.ctx,x.e,y.e))
(-){T<:Real}(ctx::Context, x::Ex{T}, c::T) = Ex{T}(opensmt_mk_minus(ctx.ctx,x.e,convert(Ex{T},c)))
(-){T<:Real}(ctx::Context, c::T, y::Ex{T}) = Ex{T}(opensmt_mk_minus(ctx.ctx,convert(Ex{T},c),x.e))
(-){T<:Real}(x::Ex{T},y::Ex{T}) = (-)(global_context(), x, y)
(-){T<:Real}(c::T,x::Ex{T}) = (-)(global_context(), c, x)
(-){T<:Real}(x::Ex{T},c::T) = (-)(global_context(), x, c)


## Real × Real -> Bool
# (>)
(>){T<:Real}(ctx::Context, x::Ex{T}, y::Ex{T}) = Ex{Bool}(opensmt_mk_gt(ctx.ctx,x.e,y.e))
(>){T<:Real}(ctx::Context, x::Ex{T}, c::T) = Ex{Bool}(opensmt_mk_gt(ctx.ctx,x.e,convert(Ex{T},c)))
(>){T<:Real}(ctx::Context, c::T, y::Ex{T}) = Ex{Bool}(opensmt_mk_gt(ctx.ctx,convert(Ex{T},c),x.e))
(>){T<:Real}(x::Ex{T},y::Ex{T}) = (>)(global_context(), x, y)
(>){T<:Real}(c::T,x::Ex{T}) = (>)(global_context(), c, x)
(>){T<:Real}(x::Ex{T},c::T) = (>)(global_context(), x, c)


# (>=)
(>=){T<:Real}(ctx::Context, x::Ex{T}, y::Ex{T}) = Ex{Bool}(opensmt_mk_geq(ctx.ctx,x.e,y.e))
(>=){T<:Real}(ctx::Context, x::Ex{T}, c::T) = Ex{Bool}(opensmt_mk_geq(ctx.ctx,x.e,convert(Ex{T},c)))
(>=){T<:Real}(ctx::Context, c::T, y::Ex{T}) = Ex{Bool}(opensmt_mk_geq(ctx.ctx,convert(Ex{T},c),x.e))
(>=){T<:Real}(x::Ex{T},y::Ex{T}) = (>=)(global_context(), x, y)
(>=){T<:Real}(c::T,x::Ex{T}) = (>=)(global_context(), c, x)
(>=){T<:Real}(x::Ex{T},c::T) = (>=)(global_context(), x, c)

# (<)
(<){T<:Real}(ctx::Context, x::Ex{T}, y::Ex{T}) = Ex{Bool}(opensmt_mk_lt(ctx.ctx,x.e,y.e))
(<){T<:Real}(ctx::Context, x::Ex{T}, c::T) = Ex{Bool}(opensmt_mk_lt(ctx.ctx,x.e,convert(Ex{T},c)))
(<){T<:Real}(ctx::Context, c::T, y::Ex{T}) = Ex{Bool}(opensmt_mk_lt(ctx.ctx,convert(Ex{T},c),x.e))
(<){T<:Real}(x::Ex{T},y::Ex{T}) = (<)(global_context(), x, y)
(<){T<:Real}(c::T,x::Ex{T}) = (<)(global_context(), c, x)
(<){T<:Real}(x::Ex{T},c::T) = (<)(global_context(), x, c)

# (<=)
(<=){T<:Real}(ctx::Context, x::Ex{T}, y::Ex{T}) = Ex{Bool}(opensmt_mk_leq(ctx.ctx,x.e,y.e))
(<=){T<:Real}(ctx::Context, x::Ex{T}, c::T) = Ex{Bool}(opensmt_mk_leq(ctx.ctx,x.e,convert(Ex{T},c)))
(<=){T<:Real}(ctx::Context, c::T, y::Ex{T}) = Ex{Bool}(opensmt_mk_leq(ctx.ctx,convert(Ex{T},c),x.e))
(<=){T<:Real}(x::Ex{T},y::Ex{T}) = (<=)(global_context(), x, y)
(<=){T<:Real}(c::T,x::Ex{T}) = (<=)(global_context(), c, x)
(<=){T<:Real}(x::Ex{T},c::T) = (<=)(global_context(), x, c)


# (==)
(==){T<:Real}(ctx::Context, x::Ex{T}, y::Ex{T}) = Ex{Bool}(opensmt_mk_eq(ctx.ctx,x.e,y.e))
(==){T<:Real}(ctx::Context, x::Ex{T}, c::T) = Ex{Bool}(opensmt_mk_eq(ctx.ctx,x.e,convert(Ex{T},c)))
(==){T<:Real}(ctx::Context, c::T, y::Ex{T}) = Ex{Bool}(opensmt_mk_eq(ctx.ctx,convert(Ex{T},c),x.e))
(==){T<:Real}(x::Ex{T},y::Ex{T}) = (==)(global_context(), x, y)
(==){T<:Real}(c::T,x::Ex{T}) = (==)(global_context(), c, x)
(==){T<:Real}(x::Ex{T},c::T) = (==)(global_context(), x, c)

# Trig
cos{T<:Real}(ctx::Context, x::Ex{T}) = Ex{T}(opensmt_mk_cos(ctx.ctx, x.e))
sin{T<:Real}(ctx::Context, x::Ex{T}) = Ex{T}(opensmt_mk_sin(ctx.ctx, x.e))

## Queries
## =======
@doc "Is predicate Y satisfiable?" ->
# is_satisfiable(ctx::Context) = [false,"UNKNOWN",true][opensmt_check(ctx.ctx)+2]
is_satisfiable(ctx::Context) = opensmt_check(ctx.ctx)
is_satisfiable() = is_satisfiable(global_context())

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

model{T}(e::Ex{T}) = model(global_context(),e)

@doc "Add (assert) a constraint to the solver" ->
add!(ctx::Context, e::Ex{Bool}) = opensmt_assert(ctx.ctx, e.e)
add!(e::Ex{Bool}) = add!(global_context(), e)

push_ctx!(ctx::Context) = opensmt_push(ctx.ctx)
push_ctx!() = push_ctx!(global_context())