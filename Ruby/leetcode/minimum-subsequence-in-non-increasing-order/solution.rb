def min_subsequence(nums)
    sorted = nums.sort.reverse
    total = sorted.sum
    running = 0
    res = []
    sorted.each do |x|
        running += x
        res << x
        break if running * 2 > total
    end
    res
end
