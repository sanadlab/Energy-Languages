from typing import List

class Solution:
    def sumOfFlooredPairs(self, nums: List[int]) -> int:
        MOD = 10**9 + 7
        max_num = max(nums)

        freq = [0] * (max_num + 1)
        for num in nums:
            freq[num] += 1

        prefix = [0] * (max_num + 1)
        for i in range(1, max_num + 1):
            prefix[i] = prefix[i - 1] + freq[i]

        ans = 0

        for denom in range(1, max_num + 1):
            if freq[denom] == 0:
                continue

            count_denom = freq[denom]
            quotient = 1
            start = denom

            while start <= max_num:
                end = min(start + denom - 1, max_num)
                count_nums = prefix[end] - prefix[start - 1]
                ans += count_denom * quotient * count_nums
                start += denom
                quotient += 1

        return ans % MOD
