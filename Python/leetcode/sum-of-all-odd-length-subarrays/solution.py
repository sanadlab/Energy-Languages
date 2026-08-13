class Solution:
    def sumOddLengthSubarrays(self, arr):
        n = len(arr)
        total = 0
        for i in range(n):
            count = ((i + 1) * (n - i) + 1) // 2
            total += count * arr[i]
        return total
