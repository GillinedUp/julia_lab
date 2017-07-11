module GraphsV1

using StatsBase

export GraphVertex, NodeType, Person, Address,
       generate_random_graph, get_random_person, get_random_address, generate_random_nodes,
       convert_to_graph,
       bfs, check_euler, partition,
       graph_to_str, node_to_str,
       test_graph

#= Single graph vertex type.
Holds node value and information about adjacent vertices =#
abstract NodeType

type Person <: NodeType
  name::String # dodano typ
end

type Address <: NodeType
  streetNumber::Int64 # dodano typ
end

type GraphVertex
  value::NodeType # dodano typ
  neighbors::Vector{GraphVertex} # dodano typ
end


# Number of graph nodes.
global const N = 800 # konstanta + zmienna globalna

# Number of graph edges.
global const K = 10000 # konstanta + zmienna globalna

global graph = Vector{GraphVertex}()

#= Generates random directed graph of size N with K edges
and returns its adjacency matrix.=#
function generate_random_graph()
  A = Array{Int64,2}(N, N)
  fill!(A, 0) # zamiast pętli wyzerowującej
  for i in sample(1:N*N, K, replace=false)
    A[i] = 1
  end
  A
end

# Generates random person object (with random name).
function get_random_person()
  Person(randstring())   # pozostaje takie same
end

# Generates random person object (with random name).
function get_random_address()
  Address(rand(1:100))   # pozostaje takie same
end

# Generates N random nodes (of random NodeType).
function generate_random_nodes()
  nodes = Vector(N)  # przealokacja
  for i = 1:N
    nodes[i] = rand() > 0.5 ? get_random_person() : get_random_address()
  end
  nodes
end

#= Converts given adjacency matrix (NxN)
  into list of graph vertices (of type GraphVertex and length N). =#
  function convert_to_graph(A, nodes)
    N = length(nodes)
    graph = collect(GraphVertex, map(n -> GraphVertex(n, GraphVertex[]), nodes)) # zamiast push!
    for i = 1:N, j = 1:N
        if A[j,i] == 1 # zamiast A[i,j]
          push!(graph[j].neighbors, graph[i])
        end
    end
    graph
  end

#= Groups graph nodes into connected parts. E.g. if entire graph is connected,
  result list will contain only one part with all nodes. =#
  function partition()
    parts = []
    remaining = Set(graph)
    visited = bfs(remaining=remaining)
    push!(parts, Set(visited))

    while !isempty(remaining)
      new_visited = bfs(visited=visited, remaining=remaining)
      push!(parts, new_visited)
    end
    parts
  end

#= Performs BFS traversal on the graph and returns list of visited nodes.
  Optionally, BFS can initialized with set of skipped and remaining nodes.
  Start nodes is taken from the set of remaining elements. =#
  function bfs(;visited=Set(), remaining=Set(graph))
    first = next(remaining, start(remaining))[1]
    q = [first]
    push!(visited, first)
    delete!(remaining, first)
    local_visited = Set([first])

    while !isempty(q)
      v = pop!(q)

      for n in v.neighbors
        if !(n in visited)
          push!(q, n)
          push!(visited, n)
          push!(local_visited, n)
          delete!(remaining, n)
        end
      end
    end
    local_visited
  end

#= Checks if there's Euler cycle in the graph by investigating
   connectivity condition and evaluating if every vertex has even degree =#
function check_euler()
  if length(partition()) == 1
    return all(map(v -> iseven(length(v.neighbors)), graph))
  end
    "Graph is not connected"
end

#= Returns text representation of the graph consisiting of each node's value
   text and number of its neighbors. =#
function graph_to_str()
  graph_str = ""
  for v in graph
    graph_str *= "****\n"

    n = v.value
    if isa(n, Person)
      node_str = "Person: $(n.name)\n"
    else isa(n, Address)
      node_str = "Street nr: $(n.streetNumber)\n"
    end

    graph_str *= node_str
    graph_str *= "Neighbors: $(length(v.neighbors))\n"
  end
  graph_str
end

#= Tests graph functions by creating 100 graphs, checking Euler cycle
  and creating text representation. =#
function test_graph()
  for i=1:100
    global graph = GraphVertex[]
    A = generate_random_graph()
    nodes = generate_random_nodes()
    graph = convert_to_graph(A, nodes)
    str = graph_to_str()
    # println(str)
    println(check_euler())
  end
end

end

# V0 18.358582 seconds (118.36 M allocations: 12.825 GB, 12.47% gc time)
# V1 4.757219 seconds (3.15 M allocations: 9.866 GB, 36.68% gc time)
# V2 4.874505 seconds (3.14 M allocations: 9.869 GB, 38.10% gc time)
