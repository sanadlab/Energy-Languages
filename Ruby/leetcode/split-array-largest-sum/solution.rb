def split_array(nums, k)
    lo = nums.max
    hi = nums.sum
    while lo < hi
        mid = (lo + hi) / 2
        cnt = 1
        cur = 0
        nums.each do |x|
            if cur + x > mid
                cnt += 1
                cur = x
            else
                cur += x
            end
        end
        if cnt <= k
            hi = mid
        else
            lo = mid + 1
        end
    end
    lo
end
