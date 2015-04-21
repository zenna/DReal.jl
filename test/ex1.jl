using dReal
using Base.Test

# Blank slate
reset_ctx!()

set_verbosity_level!(4)

# Creating boolean variables
a = Var(Bool,"a")
b = Var(Bool,"b")
c = Var(Bool,"c");

# Creating integer variables
x = Var(Int,"x" ,-100, 100)
y = Var(Int,"y" ,-100, 100)
z = Var(Int,"z" ,-100, 100)

# Creating inequality
leq1 = x - y <= 0

# Creating inequality 2
leq2 = y - z <= 0

# # Creating inequality 3
leq3 = z - x <= -1

# # Creating inequality 4
leq4 = z - x <= 0

# Asserting first inequality
add!(leq1)
push_ctx!()

# Checking for consistency
res = is_satisfiable()
@test res == true

# Asserting second inequality
add!(leq2)
push_ctx!()

# Checking for consistency
res = is_satisfiable()
@test res == true

# Asserting third inequality
add!(leq3)
push_ctx!()

# Checking for consistency
res = is_satisfiable()
@test res == false

# Backtracking one step - so the state is SAT again
pop_ctx!()

# Asserting fourth inequality
add!(leq4)

# Checking for consistency
res = is_satisfiable()
@test res == true

# Resetting context
reset_ctx!()

# # Deleting context
# delete_ctx!()
