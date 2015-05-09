@doc "Stop after 100 iterations" ->
go_to_ten{T}(niters::Int, history::Vector{Interval{T}}) = niters < 10

@doc """Find values of `vars` such that `obj` is maximized or minimized.
  Assumes obj function is between `lb` and `ub`
  
  Optimizes by solving series questions of the form:
  Is there some model such that `cost` < `x`
  Uses binary search to efficiently find smallest `x` where the answer is true

  `obj`  - The cost value to be minimized (should be asserted to be a function of other variables)
  `lb`   - lower bound on cost
  `ub`   - upper bound on cost
  `dontstop` - boolean valued function determines when to continue optimization
""" ->
function minimize{T<:Real}(ctx::Context, obj::Ex{T}, vars::Ex...;
                          lb::T = typemin(T),
                          ub::T = typemax(T),
                          dontstop::Function = go_to_ten)
  # Check there exists some cost within specified bounds
  @assert lb < ub "lower bound not less than upper bound"
  cost_bounds = Interval(lb,ub)
  add!(ctx,(obj >= lb) & (obj <= ub))
  !is_satisfiable(ctx) && error("No model has objective value between $lb and $ub")


  local cost # best cost seen so far
  local optimal_model # best model (of vars) seen so far
  local last_test_issat # wheter last test was satisfiable
  history = Interval{T}[] # History of intervals which contain best cost
  i = 0
  while dontstop(i, history)
    i += 1
    push_ctx!(ctx)
    lhalf, uhalf = mid_split(cost_bounds)
    # current_lb, current_ub = uhalf.l, uhalf.u
    current_lb, current_ub = lhalf.l, lhalf.u
    @show current_lb, current_ub
    add!(ctx,(obj >= current_lb) & (obj <= current_ub))

    if is_satisfiable(ctx)
      last_test_issat = true
      amodel = model(ctx,obj,vars...)
      cost = amodel[1]
      optimal_model = amodel[2:end] 
      @show cost, optimal_model
      # cost_bounds = Interval(cost.l, current_ub)
      cost_bounds = Interval(current_lb, cost.u)
    else
      # println("UNSAT")
      last_test_issat = false
      # cost_bounds = lhalf
      cost_bounds = uhalf 
    end

    push!(history, cost_bounds)
    pop_ctx!(ctx)
    println("\n")
  end

  if last_test_issat
    return cost, optimal_mod
  else
    # If the last test returns UNSAT, we do not know what the best cost is
    # But we do have a best interval which must contain it
    push_ctx!(ctx)
    add!(ctx,(obj >= history[end].l) & (obj <= history[end].u))
    !is_satisfiable() && error("Should be satisfiable, cost must be within $(history[end])")
    amodel = model(ctx,obj,vars...)
    cost = amodel[1]
    optimal_model = amodel[2:end] 
    pop_ctx!(ctx)
    return cost, optimal_model
  end
end

minimize(obj,vars::Ex...;args...) = minimize(global_context(), obj, vars...; args...)