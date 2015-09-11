using DReal

begin
reset_ctx!()

# Example
d = -0.45
g = 9.8

# x position
x = DReal.Var(Float64, 10.0, 15.0)

# velocity
v = DReal.Var(Float64, 10.0, 15.0)

# dx/dt =v
dx = DReal.ODE(x, v)
dv = DReal.ODE(v, -g + d*v)
t0 = DReal.Var(Float64, 0.0, 3.0)

x_0 = DReal.Var(Float64, 0.0, 15.0)
v_0 = DReal.Var(Float64, 0.0, 0.0)
x_t = DReal.Var(Float64, 0.0, 15.0)
v_t = DReal.Var(Float64, 0.0, 0.0)

zeroex = convert(DReal.Ex{Float64}, 0.0)

integral_constraint = DReal.integral([dx, dv], [x_t, v_t], zeroex, t0, [x_0, v_0])
println("Made integral constraint")

DReal.add!(integral_constraint)
println("added constraint")

res = DReal.is_satisfiable()
println("result is ", res)

end
