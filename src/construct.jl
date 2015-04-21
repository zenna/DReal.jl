## For Contructing and Querying Models
## ===================================

# TODO
# Make this lifting more compact
# Interop between Expressions of different types, e.g. Int and Float
# Multiplication division other vaarg functions
# Remaining trigonometric functions

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

## Real × Real -> Bool
for (op,opensmt_func) in boolop2opensmt
  @eval ($op){T1<:Real, T2<:Real}(ctx::Context, x::Ex{T1}, y::Ex{T2}) = 
    Ex{Bool}($opensmt_func(ctx.ctx,x.e,y.e))
  # Var and constant c
  @eval ($op){T1<:Real, T2<:Real}(ctx::Context, x::Ex{T1}, c::T2) = 
    Ex{Bool}($opensmt_func(ctx.ctx,x.e,convert(Ex{promote_type(T1,T2)},c)))

  # constant c and Var
  @eval ($op){T1<:Real, T2<:Real}(ctx::Context, c::T1, x::Ex{T2}) = 
    Ex{Bool}($opensmt_func(ctx.ctx,convert(Ex{promote_type(T1,T2)},c),x.e))
  
  # Default Contex
  @eval ($op){T1<:Real, T2<:Real}(x::Ex{T1}, y::Ex{T2}) = ($op)(global_context(), x, y)
  @eval ($op){T1<:Real, T2<:Real}(x::Ex{T1}, c::T2) = ($op)(global_context(), x, c)
  @eval ($op){T1<:Real, T2<:Real}(c::T1, x::Ex{T2}) = ($op)(global_context(), c, x)
end

# Binary Real valued functions
unaryrealop2opensmt = @compat Dict(
  :abs => opensmt_mk_abs, :exp => opensmt_mk_exp, :log => opensmt_mk_log,
  :pow => opensmt_mk_pow, :sin => opensmt_mk_sin, :cos => opensmt_mk_cos,
  :tan => opensmt_mk_tan, :asin => opensmt_mk_asin, :acos => opensmt_mk_acos,
  :atan => opensmt_mk_pow, :sinh => opensmt_mk_sinh, :cosh => opensmt_mk_cosh,
  :tanh => opensmt_mk_tanh, :atan2 => opensmt_mk_atan2)

(-){T<:Real}(ctx::Context, x::Ex{T}, y::Ex{T}) = Ex{T}(opensmt_mk_minus(ctx.ctx,x.e,y.e))
(-){T<:Real}(ctx::Context, x::Ex{T}, c::T) = Ex{T}(opensmt_mk_minus(ctx.ctx,x.e,convert(Ex{T},c)))
(-){T<:Real}(ctx::Context, c::T, y::Ex{T}) = Ex{T}(opensmt_mk_minus(ctx.ctx,convert(Ex{T},c),x.e))
(-){T<:Real}(x::Ex{T},y::Ex{T}) = (-)(global_context(), x, y)
(-){T<:Real}(c::T,x::Ex{T}) = (-)(global_context(), c, x)
(-){T<:Real}(x::Ex{T},c::T) = (-)(global_context(), x, c)

# function (+)(ctx::Context, x::Ex{Real}...)
#   T = promote_type([typeof(a) for a in x]...)
#   Ex{T}(opensmt_mk_plus(ctx.ctx, )


# (+){T<:Real}(ctx::Context, x::Ex{T}, y::Ex{T}) = Ex{T}(opensmt_mk_minus(ctx.ctx,x.e,y.e))

# ctx::opensmt_context, es::Ptr{opensmt_expr}, i::Cuint) 

# Unary Real valued functions
unaryrealop2opensmt = @compat Dict(
  :abs => opensmt_mk_abs, :exp => opensmt_mk_exp, :log => opensmt_mk_log,
  :pow => opensmt_mk_pow, :sin => opensmt_mk_sin, :cos => opensmt_mk_cos,
  :tan => opensmt_mk_tan, :asin => opensmt_mk_asin, :acos => opensmt_mk_acos,
  :atan => opensmt_mk_pow, :sinh => opensmt_mk_sinh, :cosh => opensmt_mk_cosh,
  :tanh => opensmt_mk_tanh, :atan2 => opensmt_mk_atan2)

for (op,opensmt_func) in unaryrealop2opensmt
  @eval ($op){T<:Real}(ctx::Context, x::Ex{T}) = Ex{Float64}($opensmt_func(ctx.ctx,x.e))
  @eval ($op){T<:Real}(x::Ex{T}) = ($op)(global_context(),x)
end

#TODO
# ITE
# AND OR

## Queries
## =======
@doc "Is predicate Y satisfiable?" ->
# is_satisfiable(ctx::Context) = [false,"UNKNOWN",true][opensmt_check(ctx.ctx)+2]
function is_satisfiable(ctx::Context)
  sat = opensmt_check(ctx.ctx)
  if sat == 1
    return true
  elseif sat == -1
    return false
  else 
    error("Could not determine satisfiability, dReal returned $sat")
  end
end

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

function model(ctx::Context, e::Ex{Int})
  #TODO, check dirty
  opensmt_get_value(ctx.ctx, e.e)
end

model{T}(e::Ex{T}) = model(global_context(),e)

@doc "Add (assert) a constraint to the solver" ->
add!(ctx::Context, e::Ex{Bool}) = opensmt_assert(ctx.ctx, e.e)
add!(e::Ex{Bool}) = add!(global_context(), e)

push_ctx!(ctx::Context) = opensmt_push(ctx.ctx)
push_ctx!() = push_ctx!(global_context())

pop_ctx!(ctx::Context) = opensmt_pop(ctx.ctx)
pop_ctx!() = pop_ctx!(global_context())

reset_ctx!(ctx::Context) = opensmt_reset(ctx.ctx)
reset_ctx!() = reset_ctx!(global_context())

delete_ctx!(ctx::Context) = opensmt_del_context(ctx.ctx)
delete_ctx!() = delete_ctx!(global_context())
