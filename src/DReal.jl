module DReal

using AbstractDomains
using Compat

@windows_only error("Windows not supported")

# @show joinpath(dirname(@__FILE__),"..","deps","deps.jl")
# if isfile(joinpath(dirname(@__FILE__),"..","deps","deps.jl"))
#     include("../deps/deps.jl")
# else
#     error("DReal not properly installed. Please run Pkg.build(\"DReal\")")
# end

VERSION < v"0.4-" && using Docile

deps_dir = joinpath(joinpath(Pkg.dir("DReal"),"deps"))
prefix = joinpath(deps_dir,"usr")
src_dir = joinpath(prefix,"src")
bin_dir = joinpath(prefix,"bin")
lib_dir = joinpath(prefix,"lib")

try
  @compat Libdl.dlopen(joinpath(lib_dir, "libprim.so"), Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
  @compat Libdl.dlopen(joinpath(lib_dir, "libCoinUtils.so"), Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
  @compat Libdl.dlopen(joinpath(lib_dir, "libClp.so"), Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
  @compat Libdl.dlopen(joinpath(lib_dir, "libcapd.so"), Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
  @compat Libdl.dlopen(joinpath(lib_dir, "libibex.so"), Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
  @compat Libdl.dlopen(joinpath(lib_dir, "libdreal.so"), Libdl.RTLD_LAZY|Libdl.RTLD_DEEPBIND|Libdl.RTLD_GLOBAL)
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

import Base: ifelse
import Base: convert, push!

export
  Context,
  Logic,
  model,
  init_dreal!,
  set_precision!,
  init_dreal!,
  Var,
  Ex,
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
  minimize,
  default_global_context


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
