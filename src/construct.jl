## For Contructing and Querying Models
## ===================================

## Conversion
## ==========
import Base: convert, push!

convert{T1<:Real, T2<:Real}(::Type{Ex{T1}}, ctx::Context, x::T2) =
  opensmt_mk_num_from_string(ctx.ctx, string(convert(T1,x)))
convert{T<:Real}(::Type{Ex{T}},x::Ex{T}) = x # This seems redundant!
convert{T1<:Real, T2<:Real}(t::Type{Ex{T1}}, x::T2) = convert(t,global_context(),x)

# Bool expressions
convert(::Type{Ex{Bool}}, ctx::Context, x::Bool) =
  if x opensmt_mk_true(ctx.ctx) else opensmt_mk_false(ctx.ctx) end

convert(::Type{Ex{Bool}}, x::Bool) =
  convert(Ex{Bool}, global_context(), x)

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


for (op, opensmt_func) in @compat Dict(:(-) => opensmt_mk_minus, :(/) => opensmt_mk_div)
  @eval ($op){T1<:Real, T2<:Real}(ctx::Context, x::Ex{T1}, y::Ex{T2}) =
    Ex{promote_type(T1,T2)}($opensmt_func(ctx.ctx,x.e,y.e))

  # Var and constant c
  @eval ($op){T1<:Real, T2<:Real}(ctx::Context, x::Ex{T1}, c::T2) =
    Ex{promote_type(T1,T2)}($opensmt_func(ctx.ctx,x.e,convert(Ex{promote_type(T1,T2)},c)))

  # constant c and Var
  @eval ($op){T1<:Real, T2<:Real}(ctx::Context, c::T2, x::Ex{T1}) =
    Ex{promote_type(T1,T2)}($opensmt_func(ctx.ctx,convert(Ex{promote_type(T1,T2)},c), x.e))

  # global context defaults
  @eval ($op){T1<:Real, T2<:Real}(x::Ex{T1}, y::Ex{T2}) =
    ($op)(global_context(),x,y)
  @eval ($op){T1<:Real, T2<:Real}(x::Ex{T1}, c::T2) =
    ($op)(global_context(),x,c)
  @eval ($op){T1<:Real, T2<:Real}(c::T2, x::Ex{T1}) =
    ($op)(global_context(),c,x)
end

# + and - take variable number of args
for (op, opensmt_func) in @compat Dict(:(+) => opensmt_mk_plus, :(*) => opensmt_mk_times)
  @eval ($op){T1<:Real, T2<:Real}(ctx::Context, x::Ex{T1}, y::Ex{T2}) =
    Ex{promote_type(T1,T2)}($opensmt_func(ctx.ctx,[x.e,y.e],@compat UInt32(2)))

  # Var and constant c
  @eval ($op){T1<:Real, T2<:Real}(ctx::Context, x::Ex{T1}, c::T2) =
    Ex{promote_type(T1,T2)}($opensmt_func(ctx.ctx,[x.e,convert(Ex{promote_type(T1,T2)},c)], @compat UInt32(2)))

  # constant c and Var
  @eval ($op){T1<:Real, T2<:Real}(ctx::Context, c::T2, x::Ex{T1}, ) =
    Ex{promote_type(T1,T2)}($opensmt_func(ctx.ctx,[convert(Ex{promote_type(T1,T2)},c), x.e], @compat UInt32(2)))

  # global context defaults
  @eval ($op){T1<:Real, T2<:Real}(x::Ex{T1}, y::Ex{T2}) =
    ($op)(global_context(),x,y)
  @eval ($op){T1<:Real, T2<:Real}(x::Ex{T1}, c::T2) =
    ($op)(global_context(),x,c)
  @eval ($op){T1<:Real, T2<:Real}(c::T2, x::Ex{T1}) =
    ($op)(global_context(),c,x)
end

# Unary Real valued functions
unaryrealop2opensmt = @compat Dict(
  :abs => opensmt_mk_abs, :exp => opensmt_mk_exp, :log => opensmt_mk_log,
  :(^) => opensmt_mk_pow, :sin => opensmt_mk_sin, :cos => opensmt_mk_cos,
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

## Logical Functions
## =================

## Bool × Bool -> Bool
for (op,opensmt_func) in @compat Dict(:(&) => opensmt_mk_and, :(|) => opensmt_mk_or)
  @eval ($op)(ctx::Context, x::Ex{Bool}, y::Ex{Bool}) =
    Ex{Bool}($opensmt_func(ctx.ctx,[x.e,y.e],@compat UInt32(2)))

  # Var and constant c
  @eval ($op)(ctx::Context, x::Ex{Bool}, c::Bool) =
    Ex{Bool}($opensmt_func(ctx.ctx,[x.e,convert(Ex{Bool},c)], @compat UInt32(2)))

  # constant c and Var
  @eval ($op)(ctx::Context, c::Bool, x::Ex{Bool}, ) =
    Ex{Bool}($opensmt_func(ctx.ctx,[convert(Ex{Bool},c), x.e], @compat UInt32(2)))

  # global context defaults
  @eval ($op)(x::Ex{Bool}, y::Ex{Bool}) =
    ($op)(global_context(),x,y)
  @eval ($op)(x::Ex{Bool}, c::Bool) =
    ($op)(global_context(),x,c)
  @eval ($op)(c::Bool, x::Ex{Bool}) =
    ($op)(global_context(),c,x)
end

# Implication
implies{T1<:Union(Bool, Ex{Bool}), T2<:Union(Bool, Ex{Bool})}(ctx::Context, x::T1, y::T2) = 
  (|)(ctx, (!)(ctx,x), y)
implies{T1<:Union(Bool, Ex{Bool}), T2<:Union(Bool, Ex{Bool})}(x::T1, y::T2) =
  implies(global_context(),x,y)
→ = implies

# Not
(!)(ctx::Context, e::Ex{Bool}) = Ex{Bool}(opensmt_mk_not(ctx.ctx,e.e))
(!)(e::Ex{Bool}) = !(global_context(),e)

ifelse{T}(ctx::Context, a::Ex{Bool}, b::Ex{T}, c::Ex{T}) = Ex{T}(opensmt_mk_ite(ctx.ctx, a.e, b.e, c.e))
ifelse{T}(a::Ex{Bool}, b::Ex{T}, c::Ex{T}) = ifelse(global_context(),a,b,c)

## Queries
## =======
# @doc "Is predicate Y satisfiable?" ->
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

# @doc "Return a model from the solver" ->
function model(ctx::Context, e::Ex{Float64})
  !is_satisfiable(ctx) && error("Cannot get model from unsatisfiable model")
  Interval(opensmt_get_lb(ctx.ctx,e.e), opensmt_get_ub(ctx.ctx,e.e))
end

# @doc "Return a model from the solver" ->
function model(ctx::Context, e::Ex{Bool})
  !is_satisfiable(ctx) && error("Cannot get model from unsatisfiable model")
  sat = opensmt_get_bool(ctx.ctx, e.e)
  if sat == 1
    return true
  elseif sat == -1
    return false
  else 
    error("Unknown Boolean Value")
  end
end

function model(ctx::Context, e::Ex{Int})
  !is_satisfiable(ctx) && error("Cannot get model from unsatisfiable model")
  Interval(round(Int, opensmt_get_lb(ctx.ctx,e.e)), round(Int,opensmt_get_ub(ctx.ctx,e.e)))
end

function model{T}(ctx::Context, es::Array{Ex{T}})
  !is_satisfiable(ctx) && error("Cannot get model from unsatisfiable model")
  map(e->model(ctx,e), es)
end

function model(ctx::Context, es::Ex...)
  !is_satisfiable(ctx) && error("Cannot get model from unsatisfiable model")
  map(e->model(ctx,e), es)
end

model{T}(e::Ex{T}) = model(global_context(),e)
model{T}(es::Array{Ex{T}}) = model(global_context(),es)
model(es::Ex...) = model(global_context(),es...)

# @doc "Add (assert) a constraint to the solver" ->
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

function reset_global_ctx!(l::Logic = qf_nra)
  delete_ctx!(global_context())
  create_global_ctx!(l)
end