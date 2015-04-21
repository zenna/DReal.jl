## Procedures for Controlling dReal Environment
## +===========================================

is_dreal_initialised = false

function init_dreal!()
  global is_dreal_initialised
  is_dreal_initialised == true && return
  # dlopen_shared_deps!()
  opensmt_init()
  is_dreal_initialised = true
end

# @doc "Set Verboisty of dReal output" ->
set_verbosity_level!(ctx::Context, level::Int) = opensmt_set_verbosity(ctx.ctx, @compat Int32(level))
set_verbosity_level!(level::Int) = set_verbosity_level!(global_context(), level)

# @doc "Set precision of a dReal" ->
set_precision!(ctx::Context, p::Float64) = opensmt_set_precision(ctx.ctx, p)