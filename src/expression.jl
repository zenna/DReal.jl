@doc "a dReal typed Expression" ->
immutable Ex{T}
  e::Ptr{Void}
end

@doc "Create a variable" ->
Var(ctx::Context, T::Type{Float64}, name::ASCIIString, lb::Float64, ub::Float64) =
  Ex{T}(opensmt_mk_real_var(ctx.ctx, name, lb, ub))
Var(ctx::Context, T::Type{Int64}, name::ASCIIString, lb::Int, ub::Int) =
  Ex{T}(opensmt_mk_int_var(ctx.ctx, name, lb, ub))
Var(ctx::Context,T::Type{Bool}, name::ASCIIString) =
  Ex{T}(opensmt_mk_bool_var(ctx.ctx, name))

# Global Context
Var(T, name::ASCIIString, lb, ub) = Var(global_context(), T, name, lb, ub)
Var(T, name::ASCIIString) = Var(global_context(), T, name)

## Printing
## ========
print(io::IO, e::Ex) = opensmt_print_expr(e.e)