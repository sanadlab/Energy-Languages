class Solution
  def get_coprimes(nums, edges)
    n = nums.length
    ans = Array.new(n, -1)
    adj = Array.new(n) { [] }
    (edges || []).each do |e|
      next unless e.is_a?(Array) && e.length >= 2
      u, v = e[0], e[1]
      next unless u.is_a?(Integer) && v.is_a?(Integer)
      next unless u >= 0 && u < n && v >= 0 && v < n
      adj[u] << v
      adj[v] << u
    end

    # Precompute, for each value 1..50, the values coprime with it.
    coprime = Array.new(51) { [] }
    (1..50).each do |a|
      (1..50).each do |b|
        coprime[a] << b if a.gcd(b) == 1
      end
    end

    # Ancestor stacks indexed by VALUE (size 51); answer indexed by NODE.
    depth_stack = Array.new(51) { [] }
    node_stack = Array.new(51) { [] }
    return ans if n == 0

    stack = [[0, -1, 0, false]]
    until stack.empty?
      node, parent, depth, processed = stack.pop
      val = nums[node]
      if processed
        depth_stack[val].pop
        node_stack[val].pop
        next
      end
      best_depth = -1
      best_node = -1
      coprime[val].each do |cv|
        ds = depth_stack[cv]
        if !ds.empty? && ds[-1] > best_depth
          best_depth = ds[-1]
          best_node = node_stack[cv][-1]
        end
      end
      ans[node] = best_node
      stack << [node, parent, depth, true]
      depth_stack[val] << depth
      node_stack[val] << node
      adj[node].each do |nb|
        stack << [nb, node, depth + 1, false] if nb != parent
      end
    end
    ans
  end
end
