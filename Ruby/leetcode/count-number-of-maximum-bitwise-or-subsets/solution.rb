class Solution
    def count_max_or_subsets(nums)
        n = nums.length
        max_or = nums.reduce(:|)
        count = 0

        (1..(1 << n) - 1).each do |bitmask|
            current_or = 0
            nums.each_with_index do |num, i|
                if (bitmask & (1 << i)) != 0
                    current_or |= num
                end
            end
            count += 1 if current_or == max_or
        end
        count
    end
end