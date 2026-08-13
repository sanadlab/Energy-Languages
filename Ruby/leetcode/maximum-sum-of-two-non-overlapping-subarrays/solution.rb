# @param {Integer[]} nums
# @param {Integer} first_len
# @param {Integer} second_len
# @return {Integer}
def max_sum_two_no_overlap(nums, first_len, second_len)
  n = nums.length
  pre = Array.new(n + 1, 0)
  (0...n).each { |i| pre[i + 1] = pre[i] + nums[i] }
  best = lambda do |l, m|
    res = 0
    max_l = 0
    (l + m..n).each do |i|
      max_l = [max_l, pre[i - m] - pre[i - m - l]].max
      res = [res, max_l + pre[i] - pre[i - m]].max
    end
    res
  end
  [best.call(first_len, second_len), best.call(second_len, first_len)].max
end
