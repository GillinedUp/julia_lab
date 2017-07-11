module LVExp

using DataFrames
using LVProblem

function LVExpParamRand(N)
  solArr = Vector(N)
  paramArr = Array{Float64}(6, N)
  dfArr = Vector{DataFrame}(N)
  for i = 1:N
    paramArr[1:4, i] = [rand()*3+1 for j = 1:4]
    paramArr[5:6, i] = [rand()*4+1 for j = 1:2]
    solArr[i] = LVProblem.LVexp([paramArr[j, i] for j = 1:4]..., [paramArr[5, i], paramArr[6, i]])
  end
  for i = 1:N
      dfArr[i] = DataFrame(t = solArr[i].t,
      x = map(x -> x[1], solArr[i].u),
      y = map(y -> y[2], solArr[i].u))
  end
  dfanal = DataFrame()
  dfanal[:MinPrey] = [minimum(df[:x]) for df in dfArr]
  dfanal[:MaxPrey] = [maximum(df[:x]) for df in dfArr]
  dfanal[:MeanPrey] = [mean(df[:x]) for df in dfArr]
  dfanal[:MinPredator] = [minimum(df[:y]) for df in dfArr]
  dfanal[:MaxPredator] = [maximum(df[:y]) for df in dfArr]
  dfanal[:MeanPredator] = [mean(df[:y]) for df in dfArr]
  dfanal[:Experiment] = ["exp$i" for i in 1:N]
  jt = Vector{Float64}(0)
  ju = Vector{Array{Float64,1}}(0)
  je = Vector{String}(0)
  for i = 1:N
    jt = [jt; solArr[i].t]
    ju = [ju; solArr[i].u]
    je = [je; fill("exp$i", length(solArr[i].t))]
  end
  res = DataFrame(t = jt,
  x = map(x -> x[1], ju),
  y = map(y -> y[2], ju),
  diff = map(x -> x[1], ju) .- map(y -> y[2], ju),
  experiment = je)
  return dfanal, res, paramArr
end

end
