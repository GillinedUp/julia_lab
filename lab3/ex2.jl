macro fill_series(s)
  ex = parse(s) # string -> expression
  N = length(eval(ex.args[1].args[1])) # calculate length of array to work on
  prepar(ex, N)
  for i = ex.args[1].args[2]:N
    eval(ex)
    inc_ex(ex)
  end
end

function prepar(ex, N)
  ex.args[2], minv = replace_ex(ex.args[2], N, N)
  ex.args[2] = replace_N(ex.args[2], minv-1)
  ex.args[1].args[2] = N - (minv - 1) # :(y[t]) = :y([N-(minv-1)])
end

function replace_ex(ex, N, minv)
  if(typeof(ex) == Expr) # it's an expression
    if(ex.head == :ref) # it's an ref operation
      ex.args[2].args[2] = N # :t = N
      ex.args[2] = eval(ex.args[2]) # :(N-1) = N
      minv = ex.args[2] < minv ? ex.args[2] : minv
      return ex, minv
    elseif(ex.head == :call) # it's an ariphmetic operation
      ex.args[2], minv = replace_ex(ex.args[2], N, minv) # :(y[t-1]) = :(y[N-1])
      ex.args[3], minv = replace_ex(ex.args[3], N, minv) # :(y[t-1]) = :(y[N-1])
      return ex, minv
    end
  else
    return ex, minv
  end
end

function replace_N(ex, par)
  if(typeof(ex) == Expr)
    if(ex.head == :ref) # it's an ref operation
      ex.args[2] = ex.args[2] - par # :(N-1) = N
      return ex
    elseif(ex.head == :call) # it's an ariphmetic operation
      ex.args[2] = replace_N(ex.args[2], par) # :(y[t-1]) = :(y[N-1])
      ex.args[3] = replace_N(ex.args[3], par) # :(y[t-1]) = :(y[N-1])
      return ex
    end
  else
    return ex
  end
end

function inc_ex(ex)
  ex.args[1].args[2] += 1
  ex.args[2] = rec_inc(ex.args[2])
end

function rec_inc(ex)
  if(typeof(ex) == Expr)
    if(ex.head == :ref) # it's an ref operation
      ex.args[2] += 1 # :(N-1) = N
      return ex
    elseif(ex.head == :call) # it's an ariphmetic operation
      ex.args[2] = rec_inc(ex.args[2]) # :(y[t-1]) = :(y[N-1])
      ex.args[3] = rec_inc(ex.args[3]) # :(y[t-1]) = :(y[N-1])
      return ex
    end
  else
    return ex
  end
end
