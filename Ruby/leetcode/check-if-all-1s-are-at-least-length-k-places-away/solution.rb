# @param {Integer[]} nums
# @param {Integer} k
# @return {Boolean}
def k_length_apart(nums, k)
    prev = -1
    nums.each_with_index do |v, i|
        if v == 1
            return false if prev != -1 && i - prev - 1 < k
            prev = i
        end
    end
    true
end
