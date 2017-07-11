module LVProblem

using DifferentialEquations
using DataFrames
using FileIO

eq = @ode_def_nohes LV begin
  dx = a*x - b*x*y
  dy = -c*y + d*x*y
end a=>1.5 b=>1.0 c=>3.0 d=>1.0

function LVexp(A, B, C, D, U0)
  f = LV(a = A, b = B, c = C, d = D)
  # a - growth rate of the prey
  # b - the rate at which predators destroy prey
  # c - the death rate of predators
  # d - the rate at which predators increase by consuming prey
  tspan = (0.0, 10.0)
  prob = ODEProblem(f, U0, tspan)
  sol = solve(prob, RK4(), dt = 0.005)
  return sol
end

function LVexp2file(A, B, C, D, U0, exp)
  sol = LVexp(A, B, C, D, U0)
  df = DataFrame(t = sol.t,
  x = map(x -> x[1], sol.u),
  y = map(y -> y[2], sol.u),
  experiment = exp)
  writetable("$(exp).csv", df)
end

end
