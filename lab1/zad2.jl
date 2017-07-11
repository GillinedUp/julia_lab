function typeGraph(n::DataType)
  if(n == Any)
    print(n)
    return
  else
    typeGraph(supertype(n))
  end
  print("-->", n)
  return
end
