def validate_binary_tree_nodes(n, left_child, right_child)
  m = [left_child.length, right_child.length].min
  indeg = Array.new(n, 0)
  (0...m).each do |i|
    [left_child[i], right_child[i]].each do |c|
      next if c == -1
      return false if c < 0 || c >= n
      indeg[c] += 1
      return false if indeg[c] > 1
    end
  end
  root = -1
  (0...n).each do |i|
    if indeg[i] == 0
      return false if root != -1
      root = i
    end
  end
  return false if root == -1
  visited = Array.new(n, false)
  stack = [root]
  count = 0
  until stack.empty?
    node = stack.pop
    return false if visited[node]
    visited[node] = true
    count += 1
    if node < m
      [left_child[node], right_child[node]].each do |c|
        stack.push(c) if c != -1
      end
    end
  end
  count == n
end
