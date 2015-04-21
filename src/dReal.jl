module dReal

using AbstractDomains
using Compat

# Libdl compat
if VERSION >= v"0.4.0-dev"
  RTLD_LAZY =  Libdl.RTLD_LAZY
  RTLD_DEEPBIND = Libdl.RTLD_DEEPBIND
  RTLD_GLOBAL = Libdl.RTLD_GLOBAL
  compat_dlopen = Libdl.dlopen
else
  compat_dlopen = dlopen
end

# Conversion to numeric types
if VERSION >= v"0.4.0-dev"
  compat_cuint = Cuint
  compat_cint = Cint
else
  compat_cuint = x->convert(Cuint,x)
  compat_cint = x->convert(Cint, x)
end

try
  compat_dlopen("libprim.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
  compat_dlopen("libClp.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
  compat_dlopen("libibex.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
  compat_dlopen("libgflags.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
  compat_dlopen("libglog.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
  compat_dlopen("libcapd.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
catch
  error("Could not load required shared libraries")
end

compat_dlopen("libdreal.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)

import Base: print, show
import Base:  abs, exp, log,
              ^, sin, cos,
              tan, asin, acos,
              atan, sinh, cosh,
              tanh, atan2

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
  implies


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