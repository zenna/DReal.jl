x = Var(Int,"x")
y = Var(Int,"y")
add!((x > 2) & (y < 10) & (x + 2*y == 7))
is_satisfiable()

x = Var(Float64,'x',-100,100)
y = Var(Float64,'y',-100,100)
is_satisfiable(x^2 + y^2 > 3, x^3 + y < 5)
model(x,y)


# Flyspeck
x1 = Var(Float64, "x1", 3.0, 3.14)
x2 = Var(Float64, "x2", -7.0, 5.0)
c = (2π - 2*x1*asin(cos(0.797) * sin(π/x1))) <= (-0.591 - 0.0331 *x2 + 0.506 + 1.0)
