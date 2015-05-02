# dReal.jl

This is a julia wrapper for the [dReal SMT solver](https://dreal.github.io/)

[![Build Status](https://travis-ci.org/zenna/dReal.jl.svg?branch=master)](https://travis-ci.org/zenna/dReal.jl)

# Requirements
[dReal](https://github.com/dreal/dreal3) (with shared library installed)

# Installation
dReal.jl is not yet in the official Julia Package repository.  You can still easily install it from a Julia repl with

```julia
Pkg.clone("https://github.com/zenna/dReal.jl.git")
```

## Prequisites
- dReal shared libraries

# Getting Started

```julia
using dReal
x = Var(Int,"x")
y = Var(Int,"y")
add!((x > 2) & (y < 10) & (x + 2*y == 7))
is_satisfiable()
```

The function `Var(Int,"x")` creates an integer variable named `x`.  `x` will have type `Ex{Int}`, and when we apply functions to variables we also get back typed `Ex{T}` values.  For instance `x+2y` will also have type `Ex{Int}`, but the main constraint `(x > 2) & (y < 10) & (x + 2*y == 7)` will have type `Ex{Bool}`, i.e. it is a *proposition*.

Use `add!` to assert that any proposition `Ex{Bool}` value must be true. We then use `is_satisfiable` to solve the system to determine whether there is any assignment to our variables `x` and `y` that can makes the expression `x > 2 & y < 10 & x + 2*y == 7` true.

## Real Valued Arithmetic

Similarly to the previous example, we can use create models using Real or `Float64` variables:

```julia
x = Var(Float64,'x',-100,100)
y = Var(Float64,'y',-100,100)
is_satisfiable(x^2 + y^2 > 3, x^3 + y < 5)
model(x,y)
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

dReal supports boolean operators: And (`&`), Or (`|`), Not (`!`), implies (`implies` or `\rightarrow` and if-then-else (`ifelse`).  Bi­implications are
represented using equality `==`.  The following example shows how to solve a simple set of Boolean constraints.

```julia
p = Bool('p')
q = Bool('q')
r = Bool('r')
add!(p → q & r == !q & (!p | r))
model(p,q,r)
```