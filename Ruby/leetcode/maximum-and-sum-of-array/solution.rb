def maximum_and_sum(nums, num_slots)
    n = nums.length
    full = (1 << n) - 1
    dp = Array.new(1 << n, -1)
    dp[0] = 0
    (1..num_slots).each do |slot|
        ndp = dp.dup
        (0..full).each do |mask|
            next if dp[mask] < 0
            base = dp[mask]
            (0...n).each do |i|
                next if mask[i] == 1
                nm = mask | (1 << i)
                v = base + (nums[i] & slot)
                ndp[nm] = v if v > ndp[nm]
                ((i + 1)...n).each do |j|
                    next if mask[j] == 1
                    nm2 = nm | (1 << j)
                    v2 = v + (nums[j] & slot)
                    ndp[nm2] = v2 if v2 > ndp[nm2]
                end
            end
        end
        dp = ndp
    end
    dp[full] >= 0 ? dp[full] : 0
end
