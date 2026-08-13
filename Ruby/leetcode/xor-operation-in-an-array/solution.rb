class Solution
    def xor_operation(n, start)
        result = 0
        (0...n).each do |i|
            num = start + 2 * i
            result ^= num
        end
        result
    end
end