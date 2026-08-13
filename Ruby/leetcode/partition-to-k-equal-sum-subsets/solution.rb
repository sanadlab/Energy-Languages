# @param {Integer[]} nums
# @param {Integer} k
# @return {Boolean}
def can_partition_k_subsets(nums, k)
  return false if k <= 0 || nums.length < k
  total = nums.sum
  return false if total % k != 0
  target = total / k
  nums = nums.sort.reverse
  return false if nums[0] > target
  n = nums.length
  used = Array.new(n, false)

  backtrack = lambda do |kk, cur, start|
    return true if kk == 0
    return backtrack.call(kk - 1, 0, 0) if cur == target
    i = start
    while i < n
      if !used[i] && cur + nums[i] <= target
        used[i] = true
        return true if backtrack.call(kk, cur + nums[i], i + 1)
        used[i] = false
        break if cur == 0
      end
      i += 1
    end
    false
  end

  backtrack.call(k, 0, 0)
end
