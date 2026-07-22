class Solution:
    def minNumberOperations(self, target: list[int]) -> int:
        # The minimum number of operations is the sum of all positive increments
        # compared to the previous element (considering the previous element as 0 for the first element).
        prev = 0
        ops = 0
        for x in target:
            if x > prev:
                ops += x - prev
            prev = x
        return ops
