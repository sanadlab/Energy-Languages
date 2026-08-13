def min_days(bloom_day, m, k)
    return -1 if m * k > bloom_day.length
    can_make = lambda do |day|
        bouquets = 0
        flowers = 0
        bloom_day.each do |b|
            if b <= day
                flowers += 1
                if flowers == k
                    bouquets += 1
                    flowers = 0
                end
            else
                flowers = 0
            end
        end
        bouquets >= m
    end
    lo = bloom_day.min
    hi = bloom_day.max
    while lo < hi
        mid = (lo + hi) / 2
        if can_make.call(mid)
            hi = mid
        else
            lo = mid + 1
        end
    end
    lo
end
