def median_sliding_window(nums, k)
    res = []
    n = nums.length
    i = 0
    while i + k <= n
        w = nums[i, k].sort
        if k.odd?
            median = w[k / 2].to_f
        else
            median = (w[k/2 - 1] + w[k/2]) / 2.0
        end
        res << median
        i += 1
    end
    res
end
