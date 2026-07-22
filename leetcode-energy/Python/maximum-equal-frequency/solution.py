from typing import List
from collections import defaultdict

class Solution:
    def maxEqualFreq(self, nums: List[int]) -> int:
        count = defaultdict(int)
        freq_count = defaultdict(int)
        max_freq = 0
        ans = 0

        for i, x in enumerate(nums, 1):
            old = count[x]
            if old:
                freq_count[old] -= 1

            new = old + 1
            count[x] = new
            freq_count[new] += 1
            max_freq = max(max_freq, new)

            if (
                max_freq == 1
                or freq_count[max_freq] * max_freq + 1 == i
                or (max_freq - 1) * (freq_count[max_freq - 1] + 1) + 1 == i
            ):
                ans = i

        return ans
