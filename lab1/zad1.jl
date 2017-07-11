function esieve(n)
  primes = Int64[2]
  for i = 3:n
    is_prime = true
    for j = 1:size(primes, 1)
      if i % primes[j] == 0
        is_prime = false
        break
      end
    end
    if is_prime == true
      push!(primes, i)
    end
  end
  return primes
end
