def min_start_value(nums)
    prefix = 0
    min_prefix = 0
    nums.each do |x|
        prefix += x
        min_prefix = prefix if prefix < min_prefix
    end
    [1, 1 - min_prefix].max
end
