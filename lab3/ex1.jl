function harmonic_mean(varags...)
  isempty(varags) ? throw("No arguments specified") : nothing
  ex_N = length(varags)
  ex_sum = :(1/varags[$1])
  for i = 2:ex_N
      ex_sum = :(1/varags[$i] + $ex_sum)
  end
  return :($ex_N / $ex_sum)
end
