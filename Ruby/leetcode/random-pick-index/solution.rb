class Solution

=begin
    :type nums: Integer[]
=end
    def initialize(nums)
        @nums = nums
    end


=begin
    :type target: Integer
    :rtype: Integer
=end
    def pick(target)
        count = 0
        res = -1
        @nums.each_with_index do |x, i|
            if x == target
                count += 1
                res = i if rand(count) == 0
            end
        end
        res
    end


end
