# DReal.jl

[![Build Status](https://travis-ci.org/dreal/DReal.jl.svg?branch=master)](https://travis-ci.org/dreal/DReal.jl)

This is a Julia wrapper for the [dReal SMT solver](https://dreal.github.io/).
dReal allows you to answer [satisfiability problems](http://en.wikipedia.org/wiki/Satisfiability_modulo_theories).  That is, you can ask questions of the form: __is there some assignment to my variables `x1`,`x2`,`x3`,..., that makes my formula over these variables true?__.

dReal also allows you to do non-linear, constrained, optimisation.

# Prerequisites
 - libstdc++6: In Ubuntu, please do the following install to install it.

    ```bash
    sudo add-apt-repository --yes ppa:ubuntu-toolchain-r/test # needed for 12.04
    sudo apt-get update
    sudo apt-get install libstdc++6
    ```

# Installation
DReal.jl is not yet in the official Julia Package repository.  You can still easily install it from a Julia repl with

```julia
Pkg.clone("https://github.com/dreal/DReal.jl.git")
Pkg.build("DReal")
```

dReal can then be loaded with:

```julia
using DReal
```

# Getting Started

To ask is there some Integer `x` and some Integer `y` such that `x > 2` and `y < 10` and `x + 2*y ==7`, y ou could write:

```julia
using DReal
x = Var(Int,"x")
y = Var(Int,"y")
add!((x > 2) & (y < 10) & (x + 2*y == 7))
is_satisfiable()
```

The function `Var(Int,"x")` creates an integer variable named `x`.  `x` will have type `Ex{Int}`, and when we apply functions to variables we also get back typed `Ex{T}` values.  For instance `x+2y` will also have type `Ex{Int}`, but the main constraint `(x > 2) & (y < 10) & (x + 2*y == 7)` will have type `Ex{Bool}`, i.e. it is a *proposition*.

Use `add!` to assert that any proposition `Ex{Bool}` value must be true. We then use `is_satisfiable` to solve the system to determine whether there is any assignment to our variables `x` and `y` that can makes the expression `x > 2 & y < 10 & x + 2*y == 7` true.

## Real Valued Arithmetic

Similarly to the previous example, we can use create models using Real (`Float64`) variables:

```julia
x = Var(Float64,"x",-100.0,100.0)
y = Var(Float64,"y",-100.0,100.0)
add!((x^2 + y^2 > 4) & (x^3 + y < 5))
x,y = model(x,y)
```

This example also shows how to extract a *model*. A model is an assignment of  values to variables that makes the model satisfiable.  Use `model`, and any variable used in the system to extract relevant variables in a model.  __Note__: `model` only makes sense when the system is satisfiable, otherwise it will throw an error.

## Nonlinear Arithmetic

The feature which distinguishes dReal in comparison to other SMT solvers is its powerful support for nonlinear real arithmetic.

Consider an example which slighly modifies a formula from the Flyspeck project benchmarks, taken from [the dReal homepage](http://dreal.github.io/).

![flyspeckimage](images/eq.png?raw=true)

```julia
x1 = Var(Float64, "x1", 3.0, 3.14)
x2 = Var(Float64, "x2", -7.0, 5.0)
c = (2π - 2*x1*asin(cos(0.797) * sin(π/x1))) <= (-0.591 - 0.0331 *x2 + 0.506 + 1.0)
add!(c)
is_satisfiable() # false
```

# Boolean Logic

dReal supports boolean operators: And (`&`), Or (`|`), Not (`!`), implies (`implies` or → (`\rightarrow`))   and if-then-else (`ifelse`).  Bi­implications are
represented using equality `==`.  The following example shows how to solve a simple set of Boolean constraints.

```julia
p = Bool('p')
q = Bool('q')
r = Bool('r')
add!(p → q & r == !q & (!p | r))
model(p,q,r)
```

# Optimisation

DReal.jl has tools for constrained optimisation.  One strength of optimisation in dReal is that the constraints and the objective function can be non-linear or discontinous.  The function `minimize(obj::Ex,vars::Ex...)` takes as input a value `obj` to to be minimised, and any variables `vars` whose optimal values you would like to get.  It returns a `Tuple` (a pair) of the optimal cost and corresponding values of the vars you specified.

As an example we can minimize the [rastrigins function](http://en.wikipedia.org/wiki/Rastrigin_function), which takes vector `x` of reals, each between -5.12 and 5.12  as input, and has a global minimum at `x = 0`, of 0.

```julia
rastrigin(x::Array) = 10 * length(x) + sum([xi*xi - 10*cos(2pi*xi) for xi in x])

x = Var(Float64,"x",-5.12,5.12)
y = Var(Float64,"y",-5.12,5.12)
f = Var(Float64,"f",-10.,10.)
add!(f == rastrigin([x,y]))
cost, assignment =  minimize(f,x,y; lb=-10.,ub = 10.)
println("the assignment of x=$(assignment[1]) and y=$(assignment[2]) minimises rastrigin to $cost")
```

prints:

```
> the assignment of x=[0.0 0.0] and y=[0.0 0.0] minimises rastrigin to [0.0 -0.0]
```

__caution:__ the value of the cost function must be a declared variable.  The following code may produce wrong or erratic results

```julia
x = Var(Float64,"x",-5.12,5.12)
y = Var(Float64,"y",-5.12,5.12)

# we did not declare a value for the cost
cost, assignment =  minimize(rastrigin([x,y]),x,y; lb=-10.,ub = 10.)
```
