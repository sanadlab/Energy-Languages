class Solution
    def kids_with_candies(candies, extra_candies)
        max_candies = candies.max
        result = []
        candies.each do |c|
            result << (c + extra_candies >= max_candies)
        end
        result
    end
end