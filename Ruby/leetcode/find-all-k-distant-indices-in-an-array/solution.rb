def find_k_distant_indices(nums, key, k)
  n = nums.length
  result = []
  next_idx = 0

  nums.each_with_index do |num, j|
    next unless num == key

    left = [j - k, 0].max
    right = [j + k, n - 1].min
    left = [left, next_idx].max

    if left <= right
      (left..right).each { |i| result << i }
      next_idx = right + 1
    end
  end

  result
end