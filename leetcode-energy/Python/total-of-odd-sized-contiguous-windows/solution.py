class Solution:
    def sumOddLengthSubarrays(self, arr: list[int]) -> int:
        n = len(arr)
        total_sum = 0
        for i in range(n):
            # number of subarrays including arr[i]
            left_count = i + 1
            right_count = n - i
            # number of odd length subarrays including arr[i]
            odd_count = (left_count * right_count + 1) // 2
            total_sum += arr[i] * odd_count
        return total_sum
