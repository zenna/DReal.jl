
is_dreal_initialised = false

typealias opensmt_expr Ptr{Void}
typealias opensmt_context Ptr{Void}

@enum(logic,
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
  qf_ct)         # Cost

@enum result l_false l_undef l_true

## Low Level API
## =============
opensmt_init() = ccall( (:opensmt_init, "libdreal"), Void, ())
opensmt_mk_context(l::Cuint) = 
  ccall( (:opensmt_mk_context, "libdreal"), Ptr{Void}, (Cuint,), l)

@doc "(opensmt_context c, const double p)" ->
opensmt_set_precision(ctx::opensmt_context, p::Float64) = 
  ccall( (:opensmt_set_precision, "libdreal"), Ptr{Void}, (Ptr{Void}, Float64), ctx, p)

@doc "(opensmt_context c, const double p)" ->
opensmt_get_precision(ctx::opensmt_context, p::Float64) = 
  ccall( (:opensmt_get_precision, "libdreal"), Ptr{Void}, (Ptr{Void}, Float64), ctx, p)

@doc "(opensmt_context, char * , double, double ) -> opensmt_expr" ->
opensmt_mk_real_var(ctx::opensmt_context, varname::ASCIIString, lb::Float64, ub::Float64) =
  ccall((:opensmt_mk_real_var, "libdreal"), Ptr{Void},
        (Ptr{Void}, Ptr{UInt8}, Float64, Float64), ctx, pointer(varname), lb, ub)

opensmt_mk_eq(ctx::opensmt_context, e1::opensmt_expr, e2::opensmt_expr) =
  ccall((:opensmt_mk_eq, "libdreal"), Ptr{Void},
        (Ptr{Void}, Ptr{Void}, Ptr{Void}), ctx, e1, e2)

@doc "( opensmt_context, opensmt_expr ) -> void" ->
opensmt_assert(ctx::opensmt_context, e::opensmt_expr) = 
  ccall((:opensmt_assert, "libdreal"), Void,
    (Ptr{Void}, Ptr{Void}), ctx, e)

@doc "(( opensmt_context, opensmt_expr);) -> opensmt_expr" ->
opensmt_mk_sin(ctx::opensmt_context, e::opensmt_expr) = 
  ccall((:opensmt_mk_sin, "libdreal"), Ptr{Void}, (Ptr{Void}, Ptr{Void}), ctx, e)

@doc "(( opensmt_context, opensmt_expr);) -> opensmt_expr" ->
opensmt_mk_cos(ctx::opensmt_context, e::opensmt_expr) = 
  ccall((:opensmt_mk_cos, "libdreal"), Ptr{Void}, (Ptr{Void}, Ptr{Void}), ctx, e)

opensmt_check(ctx::opensmt_context) = 
  ccall((:opensmt_check, "libdreal"), Cuint, (Ptr{Void},), ctx)

## Medium Level API
## +===============

if VERSION >= v"0.4.0-dev"
  RTLD_LAZY =  Libdl.RTLD_LAZY
  RTLD_DEEPBIND = Libdl.RTLD_DEEPBIND
  RTLD_GLOBAL = Libdl.RTLD_GLOBAL
  compat_dlopen = Libdl.dlopen
else
  compat_dlopen = dlopen
end

# function dlopen_shared_deps!()
compat_dlopen("libprim.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
compat_dlopen("libClp.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
compat_dlopen("libibex.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
compat_dlopen("libgflags.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
compat_dlopen("libglog.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
compat_dlopen("libcapd.so", RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
# end

function init_dreal!()
  global is_dreal_initialised
  is_dreal_initialised == true && return
  # dlopen_shared_deps!()
  opensmt_init()
  is_dreal_initialised = true
end

set_logic!(l::logic) = opensmt_mk_context(Cuint(l.val))

# ## Example
# ## =======
init_dreal!()
ctx = set_logic!(qf_nra)
x = opensmt_mk_real_var( ctx, "x" , -3.141592, 3.141592)
y = opensmt_mk_real_var( ctx, "y" , -3.141592, 3.141592)
eq = opensmt_mk_eq( ctx, opensmt_mk_sin(ctx, x), opensmt_mk_cos(ctx, y));
opensmt_assert( ctx, eq );
res = opensmt_check( ctx );
println("res is", res)