# @param {Integer[]} nums
# @return {Integer}
def num_of_ways(nums)
  mod = 1_000_000_007
  n = nums.length
  c = Array.new(n + 1) { Array.new(n + 1, 0) }
  (0..n).each do |i|
    c[i][0] = 1
    (1..i).each { |j| c[i][j] = (c[i - 1][j - 1] + c[i - 1][j]) % mod }
  end
  ways = nil
  ways = lambda do |arr|
    m = arr.length
    next 1 if m <= 2
    root = arr[0]
    left = []
    right = []
    (1...m).each do |i|
      if arr[i] < root
        left << arr[i]
      else
        right << arr[i]
      end
    end
    c[m - 1][left.length] * ways.call(left) % mod * ways.call(right) % mod
  end
  (ways.call(nums) - 1) % mod
end
