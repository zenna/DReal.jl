@doc """A dReal context manages all other dReal objects, global configuration options, etc.
    Objects created in one context cannot be used in another one.""" ->
immutable Context
  ctx::Ptr{Void}
end

Context(l::logic) = Context(opensmt_mk_context(Cuint(l.val)))
create_global_ctx!(logic::logic = qf_nra) = 
  (global default_global_context; default_global_context = Context(qf_nra))
create_global_ctx!()
global_context() = (global default_global_context; default_global_context)
