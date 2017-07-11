using Base.Profile

function alloc1()
  str = Array{String, 1}(100000)
end

function alloc2()
  str = Array{String, 1}(10000)
end

function proftest()
  for i in 1:500
    alloc1()
    alloc2()
  end
end

proftest()
Profile.init(delay = 0.0000001)
@profile proftest()
Profile.print()
Profile.clear()
