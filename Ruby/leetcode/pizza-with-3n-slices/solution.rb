# @param {Integer[]} slices
# @return {Integer}
def max_size_slices(slices)
  total = slices.length
  k = total / 3
  return 0 if k == 0
  a = slices[0...(total - 1)]
  b = slices[1..-1]
  [pizza_best(a, k), pizza_best(b, k)].max
end

def pizza_best(nums, k)
  n = nums.length
  neg = -(1 << 60)
  dp = Array.new(n + 1) { Array.new(k + 1, neg) }
  (0..n).each { |i| dp[i][0] = 0 }
  (1..n).each do |i|
    (1..k).each do |j|
      skip = dp[i - 1][j]
      if i >= 2
        prev = dp[i - 2][j - 1]
      elsif j == 1
        prev = 0
      else
        prev = neg
      end
      take = prev + nums[i - 1]
      dp[i][j] = [skip, take].max
    end
  end
  dp[n][k]
end
