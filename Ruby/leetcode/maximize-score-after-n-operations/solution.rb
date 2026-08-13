def max_score(nums)
    m = nums.length
    dp = Array.new(1 << m, 0)
    best = 0
    (0...(1 << m)).each do |mask|
        cnt = mask.to_s(2).count('1')
        next if cnt.odd?
        op = cnt / 2 + 1
        (0...m).each do |i|
            next if mask[i] == 1
            ((i + 1)...m).each do |j|
                next if mask[j] == 1
                nm = mask | (1 << i) | (1 << j)
                val = dp[mask] + op * nums[i].gcd(nums[j])
                dp[nm] = val if val > dp[nm]
                best = dp[nm] if dp[nm] > best
            end
        end
    end
    best
end
