function task1(N)
  for i = 1:N
    produce("1")
  end
end

function task2(N)
  for i = 1:N
    produce("2")
  end
end

function task3(N)
  for i = 1:N
    produce("3")
  end
end

function create_tasks(N)
  p1 = Task(() -> task1(N))
  p2 = Task(() -> task2(N))
  p3 = Task(() -> task3(N))
  return [p1, p2, p3]
end

function consumer(taskArr)
  i = 0 # i + 1 is current required value to print
  while in(true, map(x -> isequal(x.state, :runnable), taskArr)) # while there are unfinished tasks
    randTask = taskArr[rand(1:end)] # pick a random task
    @schedule(randTask) # add it schedule queue
    if isequal(randTask, taskArr[(i % length(taskArr)) + 1]) # if it's required task
     x = consume(randTask) # get the result
     isequal(x, nothing) ? nothing : println(x) # and print it
     i += 1
    else
     yield() # else suspend task
    end
  end
end
