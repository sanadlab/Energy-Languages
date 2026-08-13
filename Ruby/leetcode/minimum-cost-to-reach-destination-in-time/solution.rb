# @param {Integer} max_time
# @param {Integer[][]} edges
# @param {Integer[]} passing_fees
# @return {Integer}
def min_cost(max_time, edges, passing_fees)
  n = passing_fees.length
  inf = 1 << 29
  adj = Array.new(n) { [] }
  edges.each do |e|
    next if e.length < 3
    x, y, w = e[0], e[1], e[2]
    next if x < 0 || x >= n || y < 0 || y >= n || w < 0
    adj[x] << [y, w]
    adj[y] << [x, w]
  end
  dp = Array.new(max_time + 1) { Array.new(n, inf) }
  dp[0][0] = passing_fees[0]
  ans = inf
  (0..max_time).each do |t|
    (0...n).each do |u|
      cur = dp[t][u]
      next if cur >= inf
      ans = cur if u == n - 1 && cur < ans
      adj[u].each do |v, w|
        nt = t + w
        if nt <= max_time && cur + passing_fees[v] < dp[nt][v]
          dp[nt][v] = cur + passing_fees[v]
        end
      end
    end
  end
  ans >= inf ? -1 : ans
end
