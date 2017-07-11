abstract Zwierzę

type Pusty <: Zwierzę
end

type Drapieżnik <: Zwierzę
  imię::String
end

type Ofiara <: Zwierzę
  imię::String
end

type Pozycja
  zwierzę::Zwierzę
  x::Int64
  y::Int64
end

type Świat
  pole::Array{Pozycja, 1} #zdefiniuj jednowymiarową tablice Pozycji
  wymiar::Int64
end

function dodajZwierzę(s::Świat, z::Zwierzę, x0::Int64, y0::Int64)
  if(x0 > s.wymiar || y0 > s.wymiar || x0 < 1 || y0 < 1)
    throw(ArgumentError("Nie zgadzają się wymiary"))
  else
    if(findfirst(p -> ((p.x == x0) && (p.y == y0)), s.pole) != 0)
      throw(ArgumentError("Pole już jest zajęte"))
    else
      p = Pozycja(z, x0, y0)
      push!(s.pole, p)
    end
  end
end

function odległość(s::Świat, z1::Zwierzę, z2::Zwierzę)
  i1 = findfirst(p -> isequal(p.zwierzę, z1), s.pole)
  i2 = findfirst(p -> isequal(p.zwierzę, z2), s.pole)
  if(i1 == 0 || i2 == 0)
    throw(ArgumentError("Nie istnieje takich zwierząt w tym świecie"))
  else
    return abs(s.pole[i1].x - s.pole[i2].x) + abs(s.pole[i1].y - s.pole[i2].y)
  end
end

function interakcja(s::Świat, d::Drapieżnik, o::Ofiara)
  i1 = findfirst(p -> isequal(p.zwierzę, d), s.pole)
  i2 = findfirst(p -> isequal(p.zwierzę, o), s.pole)
  if(i1 == 0 || i2 == 0)
    throw(ArgumentError("Nie istnieje takich zwierząt w tym świecie"))
  else
    splice!(s.pole, i2)
  end
end

function interakcja(s::Świat, o::Ofiara, d::Drapieżnik)
  i1 = findfirst(p -> isequal(p.zwierzę, d), s.pole)
  i2 = findfirst(p -> isequal(p.zwierzę, o), s.pole)
  if(i1 == 0 || i2 == 0)
    throw(ArgumentError("Nie istnieje takich zwierząt w tym świecie"))
  else
    xn, yn = rand(0:s.wymiar, 2)
    while(findfirst(p -> ((p.x == xn) && (p.y == yn)), s.pole) != 0)
      xn, yn = rand(0:s.wymiar, 2)
    end
    splice!(s.pole, i2)
    dodajZwierzę(s, o, xn, yn)
  end
end

function interakcja(s::Świat, d1::Drapieżnik, d2::Drapieżnik)
  i1 = findfirst(p -> isequal(p.zwierzę, d1), s.pole)
  i2 = findfirst(p -> isequal(p.zwierzę, d2), s.pole)
  if(i1 == 0 || i2 == 0)
    throw(ArgumentError("Nie istnieje takich zwierząt w tym świecie"))
  else
    println("Wrrr!")
  end
end

function interakcja(s::Świat, o1::Ofiara, o2::Ofiara)
  i1 = findfirst(p -> isequal(p.zwierzę, o1), s.pole)
  i2 = findfirst(p -> isequal(p.zwierzę, o2), s.pole)
  if(i1 == 0 || i2 == 0)
    throw(ArgumentError("Nie istnieje takich zwierząt w tym świecie"))
  else
    println("Beee!")
  end
end
