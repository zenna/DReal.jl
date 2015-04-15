## Procedures for Controlling dReal Environment
## +===========================================

is_dreal_initialised = false

@enum result l_false l_undef l_true

function init_dreal!()
  global is_dreal_initialised
  is_dreal_initialised == true && return
  # dlopen_shared_deps!()
  opensmt_init()
  is_dreal_initialised = true
end

@doc "Initialise opensmt.  This (presumably?) must be called before anything else" ->
init!() = opensmt_init()

@doc "Set Verboisty of dReal output" ->
set_verbosity_level!(ctx::Context, level::Int) = opensmt_set_verbosity(ctx.ctx, level)

@doc "Set precision of a dReal" ->
set_precision!(ctx::Context, p::Float64) = opensmt_set_precision(ctx.ctx, p)