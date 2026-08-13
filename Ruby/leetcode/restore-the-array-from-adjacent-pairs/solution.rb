# @param {Integer[][]} adjacent_pairs
# @return {Integer[]}
def restore_array(adjacent_pairs)
    adj = Hash.new { |h, k| h[k] = [] }
    adjacent_pairs.each do |u, v|
        adj[u] << v
        adj[v] << u
    end
    n = adjacent_pairs.length + 1
    start = adjacent_pairs.empty? ? 0 : adjacent_pairs[0][0]
    adj.each do |node, nbrs|
        if nbrs.length == 1
            start = node
            break
        end
    end
    res = [start]
    prev = start
    cur = start
    has_prev = false
    while res.length < n
        nxt = nil
        adj[cur].each do |x|
            if !has_prev || x != prev
                nxt = x
                break
            end
        end
        break if nxt.nil?
        res << nxt
        prev = cur
        has_prev = true
        cur = nxt
    end
    res
end
