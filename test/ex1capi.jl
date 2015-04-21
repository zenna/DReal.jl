using dReal
import dReal: opensmt_context, opensmt_set_verbosity, opensmt_assert, opensmt_check, opensmt_print_expr, opensmt_mk_context,
              opensmt_mk_bool_var, opensmt_mk_int_var, opensmt_mk_minus, opensmt_mk_leq, opensmt_mk_num_from_string,
              opensmt_push, opensmt_pop, opensmt_reset, opensmt_del_context
using Base.Test

# Blank slate
reset_ctx!()

print( "Creating context\n" )
ctx = opensmt_mk_context(Cuint(1))

 # Setting verbosity
opensmt_set_verbosity(ctx, Cint(4))

 # Creating boolean variables
print( "Creating some boolean variables\n" )
a = opensmt_mk_bool_var( ctx, "a" )
b = opensmt_mk_bool_var( ctx, "b" )
c = opensmt_mk_bool_var( ctx, "c" )

 # Creating integer variables
print( "Creating some integer variables\n" )
x = opensmt_mk_int_var( ctx, "x" , -100, 100)
y = opensmt_mk_int_var( ctx, "y" , -100, 100)
z = opensmt_mk_int_var( ctx, "z" , -100, 100)
 # Creating inequality
print( "Creating x - y <= 0\n" )

print( "  Creating x - y\n" )
minus = opensmt_mk_minus( ctx, x, y )
print( "  Expression created: " )
opensmt_print_expr( minus )
print( "\n" )

print( "  Creating 0\n" )
zero = opensmt_mk_num_from_string( ctx, "0" )
print( "  Expression created: " )
opensmt_print_expr( zero )
print( "\n" )

print( "  Creating x - y <= 0\n" )
leq = opensmt_mk_leq( ctx, minus, zero )
print( "  Expression created: " )
opensmt_print_expr( leq )
print( "\n" )

 # Creating inequality 2
print( "Creating y - z <= 0\n" )
minus2 = opensmt_mk_minus( ctx, y, z )
leq2 = opensmt_mk_leq( ctx, minus2, zero )
print( "  Expression created: " )
opensmt_print_expr( leq2 )
print( "\n" )

 # Creating inequality 3
print( "Creating z - x <= -1\n" )
minus3 = opensmt_mk_minus( ctx, z, x )
mone = opensmt_mk_num_from_string( ctx, "-1" )
leq3 = opensmt_mk_leq( ctx, minus3, mone )
print( "  Expression created: " )
opensmt_print_expr( leq3 )
print( "\n" )

 # Creating inequality 4
print( "Creating z - x <= 0\n" )
minus4 = opensmt_mk_minus( ctx, z, x )
leq4 = opensmt_mk_leq( ctx, minus4, zero )
print( "  Expression created: " )
opensmt_print_expr( leq4 )
print( "\n" )

 # Asserting first inequality
print( "Asserting ")
opensmt_print_expr( leq )
print( "\n" )
opensmt_assert( ctx, leq )
opensmt_push( ctx )

println("Expression is")
opensmt_print_expr( leq )

# Checking for consistency
println( "\nChecking for consistency: " )
res = opensmt_check( ctx )
println( "res = $(res == -1 ? "unsat" : "sat")")
@test res == 1

# Asserting second inequality
print( "Asserting ")
opensmt_print_expr( leq2 )
print( "\n" )
opensmt_assert( ctx, leq2 )
opensmt_push( ctx )

 # Checking for consistency
print( "\nChecking for consistency: " )
res = opensmt_check( ctx )
println( "res = $(res == -1 ? "unsat" : "sat")")
@test res == 1

# Asserting third inequality
print( "\nAsserting ")
opensmt_print_expr( leq3 )
print( "\n" )
opensmt_assert( ctx, leq3 )
opensmt_push( ctx )

# Checking for consistency - it is UNSAT
print( "\nChecking for consistency: " )
res = opensmt_check( ctx )
@test res == -1

 # Backtracking one step - so the state is SAT again
opensmt_pop( ctx )
print( "Backtracking one step\n\n" )

# Asserting fourth inequality
print( "Asserting ")
opensmt_print_expr( leq4 )
print( "\n" )
opensmt_assert( ctx, leq4 )

 # Checking for consistency
print( "\nChecking for consistency: " )
res = opensmt_check( ctx )
println( "res = $(res == -1 ? "unsat" : "sat")")
@test res == 1

# Resetting context
print( "Resetting context\n" )
opensmt_reset( ctx )

# # Deleting context
# print( "Deleting context\n" )
# opensmt_del_context( ctx )