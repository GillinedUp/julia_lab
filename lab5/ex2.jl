using Plots
using Match
Plots.gr()

@everywhere begin

function generate_julia(z, c = 2; maxiter = 200)
    for i = 1:maxiter
        if abs(z) > 2
            return i-1
        end
        z = z^2 + c
    end
    maxiter
end

function calc_julia!(julia_set, xrange, yrange, c; maxiter = 200, height = 400, width_start = 1, width_end = 400)
   for x = width_start:width_end
        for y = 1:height
            z = xrange[x] + 1im*yrange[y]
            julia_set[x, y] = generate_julia(z, c, maxiter = maxiter)
        end
    end
    return julia_set
end

function calc_julia!(julia_set, xrange, yrange, c, maxiter, height, width_start, width_end)
   for x = width_start:width_end
        for y = 1:height
            z = xrange[x] + 1im*yrange[y]
            julia_set[x, y] = generate_julia(z, c, maxiter = maxiter)
        end
    end
    return julia_set
end

function calc_julia_pfor!(julia_set, xrange, yrange, c; maxiter = 200, height = 400, width_start = 1, width_end = 400)
   @sync @parallel for x = width_start:width_end
        for y = 1:height
            z = xrange[x] + 1im*yrange[y]
            julia_set[x, y] = generate_julia(z, c, maxiter = maxiter)
        end
    end
end

function calc_julia_pmap!(arr_set, xarr_set, yrange, c; maxiter = 200, height = 400, width_start = 1, width_end = 400)
  arr = pmap((a,b) -> calc_julia!(a, b, yrange, c, maxiter, height, width_start, width_end), arr_set, xarr_set)
end

function myrange(q::SharedArray)
    idx = indexpids(q)
    if idx == 0
        return 1:0, 1:0
    end
    nchunks = length(procs(q))
    splits = [round(Int, s) for s in linspace(0,size(q,2),nchunks+1)]
    1:size(q,1), splits[idx]+1:splits[idx+1]
end

function calc_julia_range!(julia_set, xrange, yrange, c, irange, jrange, maxiter)
  for x in irange
       for y in jrange
           z = xrange[x] + 1im*yrange[y]
           julia_set[x, y] = generate_julia(z, c, maxiter = maxiter)
       end
   end
   return julia_set
end

calc_julia_shared_range!(julia_set, xrange, yrange, c, maxiter) = calc_julia_range!(julia_set, xrange, yrange, c, myrange(julia_set)..., maxiter)

function calc_julia_shared!(julia_set, xrange, yrange, c; maxiter = 200)
  @sync begin
      for p in procs(julia_set)
          @async remotecall_wait(calc_julia_shared_range!, p, julia_set, xrange, yrange, c, maxiter)
      end
  end
  return julia_set
end

end # end @everywhere

function calc_julia_main(h, w, ver; c = -0.70176-0.3842im)
  chunks = 10
  xmin, xmax = -2,2
  ymin, ymax = -1,1
  xrange = linspace(xmin, xmax, w)
  yrange = linspace(ymin, ymax, h)
  julia_set = SharedArray(Int64, (w, h))
  xarr = collect(xrange)
  xarr_set = Array{Float64}[]
  arr_set = Array{Int64}[]
  step = div(w, chunks)
  for i = 1:step:w
    push!(arr_set, julia_set[i:i+step-1, :])
    push!(xarr_set, xarr[i:i+step-1])
  end
  @match ver begin
    1 => @time calc_julia!(julia_set, xrange, yrange, c, height = h, width_end = w)
    2 => @time calc_julia_pfor!(julia_set, xrange, yrange, c, height = h, width_end = w)
    3 => begin
      @time arr = calc_julia_pmap!(arr_set, xarr_set, yrange, c, height = h, width_end = step)
      julia_set = vcat([arr[i] for i = 1:length(arr)]...)
    end
    _ => @time calc_julia_shared!(julia_set, xrange, yrange, c)
  end
  Plots.heatmap(xrange, yrange, julia_set)
  png("julia")
end

function calc_julia_main_test(h, w; c = -0.70176-0.3842im)
  chunks = 10
  xmin, xmax = -2,2
  ymin, ymax = -1,1
  xrange = linspace(xmin, xmax, w)
  yrange = linspace(ymin, ymax, h)
  julia_set = SharedArray(Int64, (w, h))
  xarr = collect(xrange)
  xarr_set = Array{Float64}[]
  arr_set = Array{Int64}[]
  step = div(w, chunks)
  for i = 1:step:w
    push!(arr_set, julia_set[i:i+step-1, :])
    push!(xarr_set, xarr[i:i+step-1])
  end
  calc_julia!(julia_set, xrange, yrange, c, height = h, width_end = w)
  @time calc_julia!(julia_set, xrange, yrange, c, height = h, width_end = w)
  calc_julia_pfor!(julia_set, xrange, yrange, c, height = h, width_end = w)
  @time calc_julia_pfor!(julia_set, xrange, yrange, c, height = h, width_end = w)
  arr = calc_julia_pmap!(arr_set, xarr_set, yrange, c, height = h, width_end = step)
  @time arr = calc_julia_pmap!(arr_set, xarr_set, yrange, c, height = h, width_end = step)
  calc_julia_shared!(julia_set, xrange, yrange, c)
  @time calc_julia_shared!(julia_set, xrange, yrange, c)
end
