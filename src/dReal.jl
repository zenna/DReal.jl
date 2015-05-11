module dReal

using AbstractDomains
using Compat

VERSION < v"0.4-" && using Docile

try
  @compat Libdl.dlopen("libprim.so", Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
  @compat Libdl.dlopen("libClp.so", Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
  @compat Libdl.dlopen("libibex.so", Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
  @compat Libdl.dlopen("libgflags.so", Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
  @compat Libdl.dlopen("libglog.so", Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
  @compat Libdl.dlopen("libcapd.so", Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
  @compat Libdl.dlopen("libdreal.so", Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
catch e
  println("Could not load required shared libraries")
  rethrow(e)
end

import Base: print, show
import Base:  abs, exp, log,
              ^, sin, cos,
              tan, asin, acos,
              atan, sinh, cosh,
              tanh, atan2, sqrt

export
  Context,
  Logic,
  model,
  init_dreal!,
  set_precision!,
  init_dreal!,
  Var,
  add!,
  is_satisfiable,
  global_context,
  set_verbosity_level!,
  push_ctx!,
  pop_ctx!,
  reset_ctx!,
  delete_ctx!,
  reset_global_ctx!,
  →,
  implies,
  minimize


include("wrap_capi.jl")
# Julia 0.3 does not have enums
if VERSION >= v"0.4.0-dev"
  include("logic.jl")
else
  include("logicv3.jl")
end
include("context.jl")
include("environment.jl")
include("expression.jl")
include("construct.jl")
include("optimize.jl")


export
  qf_uf,         # Uninterpreted Functions
  qf_nra,        # Non-Linear Real Arithmetic
  qf_nra_ode,    # Non-Linear Real Arithmetic
  qf_bv,         # BitVectors
  qf_rdl,        # Real difference logics
  qf_idl,        # Integer difference logics
  qf_lra,        # Real linear arithmetic
  qf_lia,        # Integer linear arithmetic
  qf_ufidl,      # UF + IDL
  qf_uflra,      # UF + LRA
  qf_bool,       # Only booleans
  qf_ct          # Cost

init_dreal!()
end