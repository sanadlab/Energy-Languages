def shuffle(nums, n)
    m = nums.length / 2
    res = []
    (0...m).each do |i|
        res << nums[i] << nums[i + m]
    end
    res
end
