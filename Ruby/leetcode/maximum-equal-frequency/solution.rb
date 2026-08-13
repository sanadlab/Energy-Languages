# @param {Integer[]} nums
# @return {Integer}
def max_equal_freq(nums)
    n = nums.length
    count = Array.new(100001, 0)
    freq = Array.new(n + 1, 0)
    max_f = 0
    res = 0
    (0...n).each do |i|
        v = nums[i]
        freq[count[v]] -= 1 if count[v] > 0
        count[v] += 1
        freq[count[v]] += 1
        max_f = count[v] if count[v] > max_f
        if max_f == 1 ||
           freq[max_f] * max_f == i ||
           (freq[max_f] == 1 && (max_f - 1) * (freq[max_f - 1] + 1) == i)
            res = i + 1
        end
    end
    res
end
