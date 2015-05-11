# @doc """A dReal context manages all other dReal objects, global configuration options, etc.
#     Objects created in one context cannot be used in another one.""" ->
type Context
  ctx::Ptr{Void}
  vars::Set{ASCIIString}
end

Context(ctx::Ptr{Void}) = Context(ctx,Set{ASCIIString}())
Context(l::Logic) = Context(opensmt_mk_context(@compat UInt32(l.val)))

add_vars!(ctx::Context, v::Set{ASCIIString}) = push!(ctx.vars,v...)
add_vars!(ctx::Context, v::ASCIIString) = push!(ctx.vars,v)

create_global_ctx!(l::Logic = qf_nra) = 
  (global default_global_context; default_global_context = Context(l))
create_global_ctx!()
global_context() = (global default_global_context; default_global_context)
