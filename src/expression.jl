@doc "a dReal typed Expression" ->
immutable Ex{T}
  e::Ptr{Void}
end

@doc "Create a variable"
Var(ctx::Context, name::ASCIIString, T::Type{Float64}, lb::Float64, ub::Float64) =
  Ex{T}(opensmt_mk_real_var(ctx.ctx, name, lb, ub))
Var(name::ASCIIString, T::Type{Float64}, lb, ub) = Var(global_context(), name, lb, ub)