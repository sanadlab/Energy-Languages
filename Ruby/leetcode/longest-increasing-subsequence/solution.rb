# @param {Integer[]} nums
# @return {Integer}
def length_of_lis(nums)
    tails = []
    nums.each do |x|
        lo = 0
        hi = tails.length
        while lo < hi
            mid = (lo + hi) / 2
            if tails[mid] < x
                lo = mid + 1
            else
                hi = mid
            end
        end
        tails[lo] = x
    end
    tails.length
end
