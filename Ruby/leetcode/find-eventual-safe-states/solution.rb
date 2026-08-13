# @param {Integer[][]} graph
# @return {Integer[]}
def eventual_safe_nodes(graph)
  n = graph.size
  # States: 0 = unvisited, 1 = visiting, 2 = safe
  state = Array.new(n, 0)

  dfs = lambda do |node|
    return state[node] == 2 if state[node] != 0
    state[node] = 1
    graph[node].each do |nei|
      return false if state[nei] == 1 || !dfs.call(nei)
    end
    state[node] = 2
    true
  end

  result = []
  (0...n).each do |i|
    result << i if dfs.call(i)
  end
  result
end