## Medium Level API
## +===============

is_dreal_initialised = false

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


function init_dreal!()
  global is_dreal_initialised
  is_dreal_initialised == true && return
  # dlopen_shared_deps!()
  opensmt_init()
  is_dreal_initialised = true
end

set_logic!(l::logic) = opensmt_mk_context(Cuint(l.val))