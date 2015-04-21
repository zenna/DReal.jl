# @doc """A dReal context manages all other dReal objects, global configuration options, etc.
#     Objects created in one context cannot be used in another one.""" ->
immutable Context
  ctx::Ptr{Void}
end

Context(l::Logic) = Context(opensmt_mk_context(@compat UInt32(l.val)))
create_global_ctx!(l::Logic = qf_nra) = 
  (global default_global_context; default_global_context = Context(l))
create_global_ctx!()
global_context() = (global default_global_context; default_global_context)
